import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:yummy/data/database/recipe_db.dart';
import 'package:yummy/data/repositories/db_repository.dart';
import 'package:yummy/models/ingredient.dart';
import 'package:drift/drift.dart' hide isNotNull; // Скрываем конфликтное имя

// Импортируем сгенерированный файл
import 'db_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RecipeDatabase>(),
  MockSpec<RecipeDao>(),
  MockSpec<IngredientDao>(),
])
void main() {
  group('DBRepository', () {
    late MockRecipeDatabase mockDb;
    late MockRecipeDao mockRecipeDao;
    late MockIngredientDao mockIngredientDao;
    late DBRepository dbRepository;

    setUp(() {
      mockDb = MockRecipeDatabase();
      mockRecipeDao = MockRecipeDao();
      mockIngredientDao = MockIngredientDao();

      // Настраиваем поведение моков
      when(mockDb.recipeDao).thenReturn(mockRecipeDao);
      when(mockDb.ingredientDao).thenReturn(mockIngredientDao);

      dbRepository = DBRepository(recipeDatabase: mockDb);
    });

    test('can instantiate', () {
      expect(dbRepository, isNotNull);
      expect(dbRepository.recipeDatabase, equals(mockDb));
    });

    test('can findAllIngredients', () async {
      // Arrange
      final randomIngredients = [
        const DbIngredientData(id: 1, recipeId: 123, name: 'Pasta', amount: 1.0),
        const DbIngredientData(id: 2, recipeId: 123, name: 'Garlic', amount: 1.0),
      ];

      when(mockIngredientDao.findAllIngredients())
          .thenAnswer((_) async => randomIngredients);

      // Act
      final result = await dbRepository.findAllIngredients();

      // Assert
      verify(mockIngredientDao.findAllIngredients()).called(1);
      expect(result.length, equals(2));
      expect(result[0].name, equals('Pasta'));
    });
  });
}
