import 'package:test/test.dart';
import 'package:yummy/models/models.dart';

void main() {
  group('Recipe', () {
    test('can instantiate', () {
      // Arrange
      late Recipe recipe;
      // Act
      recipe = const Recipe(
        id: '1',
        title: 'Test',
        imageUrl: 'http',
        brand: 'FitHerb',
      );
      // Assert
      expect(recipe, isNotNull);
    });

    test('can receive parameters', () {
      const id = '123';
      const title = 'Pasta with Garlic';
      const image = 'http://image.jpg';
      const brand = 'FitHerb';
      const ingredients = [
        Ingredient(id: 1, recipeId: 123, name: 'Pasta', amount: 1.0),
        Ingredient(id: 2, recipeId: 123, name: 'Garlic', amount: 1.0),
      ];

      final recipe = Recipe(
        id: id,
        title: title,
        imageUrl: image,
        brand: brand,
        ingredients: ingredients,
      );

      expect(recipe.id, equals(id));
      expect(recipe.title, equals(title));
      expect(recipe.imageUrl, equals(image));
      expect(recipe.brand, equals(brand));
      expect(recipe.ingredients, equals(ingredients));
    });
  });
}
