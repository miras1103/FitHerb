import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:yummy/data/database/recipe_db.dart';
import 'package:yummy/data/repositories/db_repository.dart';
import 'package:drift/drift.dart' hide isNotNull;

// Импортируем сгенерированный файл
import 'db_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RecipeDatabase>(),
  MockSpec<RecipeDao>(),
  MockSpec<IngredientDao>(),
])
void main() {
  group('FitHerb DBRepository', () {
    late MockRecipeDatabase mockDb;
    late MockRecipeDao mockRecipeDao;
    late MockIngredientDao mockIngredientDao;
    late DBRepository dbRepository;

    setUp(() {
      mockDb = MockRecipeDatabase();
      mockRecipeDao = MockRecipeDao();
      mockIngredientDao = MockIngredientDao();

      when(mockDb.recipeDao).thenReturn(mockRecipeDao);
      when(mockDb.ingredientDao).thenReturn(mockIngredientDao);

      dbRepository = DBRepository(recipeDatabase: mockDb);
    });

    test('can instantiate FitHerb repository', () {
      expect(dbRepository, isNotNull);
      expect(dbRepository.recipeDatabase, equals(mockDb));
    });

    test('can findAllProducts (ingredients)', () async {
      // Arrange
      final mockProducts = [
        const DbIngredientData(id: 1, recipeId: 101, name: 'Vitamin C Capsules', amount: 1.0),
        const DbIngredientData(id: 2, recipeId: 101, name: 'Zinc Tablets', amount: 1.0),
      ];

      when(mockIngredientDao.findAllIngredients())
          .thenAnswer((_) async => mockProducts);

      // Act
      final result = await dbRepository.findAllIngredients();

      // Assert
      verify(mockIngredientDao.findAllIngredients()).called(1);
      expect(result.length, equals(2));
      expect(result[0].name, equals('Vitamin C Capsules'));
    });
  });
}
