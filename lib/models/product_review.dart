import 'package:cloud_firestore/cloud_firestore.dart';

class ProductReview {
  final String id;
  final String userId;
  final String email;
  final String text;
  final DateTime timestamp;
  final String productId;

  ProductReview({
    required this.id,
    required this.userId,
    required this.email,
    required this.text,
    required this.timestamp,
    required this.productId,
  });

  factory ProductReview.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductReview(
      id: snapshot.id,
      userId: data['userId'] as String? ?? '',
      email: data['email'] as String? ?? 'Anonymous',
      text: data['text'] as String? ?? '',
      timestamp: data['timestamp'] != null 
          ? (data['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
      productId: data['productId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'productId': productId,
    };
  }
}
