import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_review.dart';
import 'user_dao.dart';

class ReviewDao {
  final UserDao userDao;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('product_reviews');

  ReviewDao(this.userDao);

  void sendReview(String text, String productId) {
    if (text.trim().isEmpty) return;
    
    final review = ProductReview(
      id: '', 
      userId: userDao.userId() ?? 'anonymous',
      email: userDao.email() ?? 'Anonymous',
      text: text,
      timestamp: DateTime.now(),
      productId: productId,
    );
    
    // Firebase автоматически добавит отзыв в локальный кэш, 
    // поэтому он появится в Stream мгновенно
    collection.add(review.toJson());
  }

  Stream<List<ProductReview>> getReviewsStream(String productId) {
    // Убираем orderBy из запроса Firestore, чтобы НЕ требовать индекс.
    // Сортировку сделаем вручную в методе map.
    return collection
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) {
      final reviews = snapshot.docs
          .map((doc) => ProductReview.fromSnapshot(doc))
          .toList();
      
      // Сортируем: новые отзывы сверху
      reviews.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return reviews;
    });
  }
}
