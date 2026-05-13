import 'package:test/test.dart';
import 'package:yummy/models/models.dart';

void main() {
  group('Vitamin (Recipe) Model', () {
    test('can instantiate FitHerb vitamin', () {
      const vitamin = Recipe(
        id: 'vit_c_001',
        title: 'Vitamin C 1000mg',
        imageUrl: 'assets/restaurants/vitaminc.jpg',
        brand: 'Immunity Support',
      );
      expect(vitamin.id, equals('vit_c_001'));
      expect(vitamin.title, equals('Vitamin C 1000mg'));
      expect(vitamin.brand, equals('Immunity Support'));
    });

    test('can hold products (ingredients)', () {
      const product = Ingredient(id: 1, name: 'Vitamin C Capsules', amount: 1.0);
      
      const vitamin = Recipe(
        id: '1',
        title: 'Vitamin C Pack',
        imageUrl: 'http',
        brand: 'FitHerb',
        ingredients: [product],
      );

      expect(vitamin.ingredients.length, 1);
      expect(vitamin.ingredients.first.name, equals('Vitamin C Capsules'));
    });
  });
}
