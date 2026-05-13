import 'package:test/test.dart';
import 'package:yummy/models/product_review.dart';

void main() {
  group('ProductReview Model', () {
    test('can instantiate with parameters', () {
      final now = DateTime.now();
      final review = ProductReview(
        id: 'rev123',
        userId: 'user1',
        email: 'test@mail.com',
        text: 'This Vitamin C is great!',
        timestamp: now,
        productId: 'vit_c_001',
      );

      expect(review.id, 'rev123');
      expect(review.text, 'This Vitamin C is great!');
      expect(review.email, 'test@mail.com');
      expect(review.timestamp, now);
    });

    test('toJson returns correct map', () {
      final review = ProductReview(
        id: 'rev123',
        userId: 'user1',
        email: 'test@mail.com',
        text: 'Energy boost!',
        timestamp: DateTime.now(),
        productId: 'vit_b_002',
      );

      final json = review.toJson();

      expect(json['userId'], 'user1');
      expect(json['email'], 'test@mail.com');
      expect(json['text'], 'Energy boost!');
      expect(json['productId'], 'vit_b_002');
      // timestamp в toJson возвращает FieldValue.serverTimestamp(), 
      // что обычно проверяется отдельно, но мы проверили базовые поля
    });
  });
}
