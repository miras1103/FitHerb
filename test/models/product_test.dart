import 'package:test/test.dart';
import 'package:yummy/models/ingredient.dart';

void main() {
  group('Product (Ingredient) Model', () {
    test('can instantiate FitHerb product', () {
      final product = const Ingredient(
        id: 101,
        name: 'Vitamin C 1000mg',
        amount: 1.0,
      );
      expect(product.name, equals('Vitamin C 1000mg'));
      expect(product.id, equals(101));
    });

    test('can instantiate from JSON (from FitHerb database)', () {
      final jsonMap = <String, dynamic>{
        'id': 202,
        'recipeId': 1,
        'name': 'B-Complex Liquid',
        'amount': 2.5,
      };

      final product = Ingredient.fromJson(jsonMap);

      expect(product.id, equals(202));
      expect(product.name, equals('B-Complex Liquid'));
      expect(product.amount, equals(2.5));
    });
  });
}
