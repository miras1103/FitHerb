import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'order_manager.dart';
import 'user_dao.dart';

class OrderDao {
  final UserDao userDao;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('orders');

  OrderDao(this.userDao);

  Future<void> saveOrder(Order order) async {
    final userId = userDao.userId();
    if (userId == null) return;

    final data = order.toJson();
    data['userId'] = userId;
    
    await collection.add(data);
  }

  Stream<List<Order>> getOrdersStream() {
    final userId = userDao.userId();
    if (userId == null) return Stream.value([]);

    // Убираем orderBy из запроса Firestore, чтобы не требовать создания индекса.
    return collection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) => Order.fromSnapshot(doc)).toList();
      
      // Сортируем список вручную: сначала новые заказы
      orders.sort((a, b) {
        if (a.timestamp == null || b.timestamp == null) return 0;
        return b.timestamp!.compareTo(a.timestamp!);
      });
      
      return orders;
    });
  }
}
