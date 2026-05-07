import 'package:drift/drift.dart';
import 'connection.dart' as impl;
import '../../models/models.dart';
import '../../models/ingredient.dart';

part 'recipe_db.g.dart';

class DbRecipe extends Table {
  IntColumn get id => integer()();
  TextColumn get label => text()();
  TextColumn get image => text()();
  TextColumn get description => text()();
  BoolColumn get bookmarked => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class DbIngredient extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
}

@DriftDatabase(
  tables: [DbRecipe, DbIngredient],
  daos: [RecipeDao, IngredientDao],
)
class RecipeDatabase extends _$RecipeDatabase {
  RecipeDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [DbRecipe])
class RecipeDao extends DatabaseAccessor<RecipeDatabase> with _$RecipeDaoMixin {
  final RecipeDatabase db;
  RecipeDao(this.db) : super(db);

  Future<List<DbRecipeData>> findAllRecipes() => select(dbRecipe).get();

  Stream<List<Recipe>> watchAllRecipes() {
    return select(dbRecipe).watch().map((rows) {
      final recipes = <Recipe>[];
      for (final row in rows) {
        final recipe = dbRecipeToModelRecipe(row, <Ingredient>[]);
        if (!recipes.any((r) => r.id == recipe.id)) {
          recipes.add(recipe);
        }
      }
      return recipes;
    });
  }

  Future<List<DbRecipeData>> findRecipeById(int id) {
    return (select(dbRecipe)..where((tbl) => tbl.id.equals(id))).get();
  }

  Future<int> insertRecipe(Insertable<DbRecipeData> recipe) =>
      into(dbRecipe).insert(recipe, mode: InsertMode.insertOrReplace);

  Future deleteRecipe(int id) =>
      (delete(dbRecipe)..where((tbl) => tbl.id.equals(id))).go();
}

@DriftAccessor(tables: [DbIngredient])
class IngredientDao extends DatabaseAccessor<RecipeDatabase>
    with _$IngredientDaoMixin {
  final RecipeDatabase db;
  IngredientDao(this.db) : super(db);

  Future<List<DbIngredientData>> findAllIngredients() =>
      select(dbIngredient).get();

  Stream<List<DbIngredientData>> watchAllIngredients() =>
      select(dbIngredient).watch();

  Future<List<DbIngredientData>> findRecipeIngredients(int id) {
    return (select(dbIngredient)..where((tbl) => tbl.recipeId.equals(id)))
        .get();
  }

  Future<int> insertIngredient(Insertable<DbIngredientData> ingredient) =>
      into(dbIngredient).insert(ingredient);

  Future deleteIngredient(int id) =>
      (delete(dbIngredient)..where((tbl) => tbl.id.equals(id))).go();

  Future deleteRecipeIngredients(int recipeId) {
    return (delete(dbIngredient)
          ..where((tbl) => tbl.recipeId.equals(recipeId)))
        .go();
  }
}

Recipe dbRecipeToModelRecipe(
  DbRecipeData recipe,
  List<Ingredient> ingredients,
) {
  return Recipe(
    id: recipe.id.toString(),
    title: recipe.label,
    imageUrl: recipe.image,
    brand: recipe.description,
    ingredients: ingredients,
  );
}

Insertable<DbRecipeData> recipeToInsertableDbRecipe(Recipe recipe) {
  return DbRecipeCompanion.insert(
    id: Value(int.tryParse(recipe.id) ?? 0),
    label: recipe.title,
    image: recipe.imageUrl,
    description: recipe.brand,
    bookmarked: true,
  );
}

Ingredient dbIngredientToIngredient(DbIngredientData ingredient) {
  return Ingredient(
    id: ingredient.id,
    recipeId: ingredient.recipeId.toString(),
    name: ingredient.name,
    weight: ingredient.amount,
  );
}

DbIngredientCompanion ingredientToInsertableDbIngredient(
  Ingredient ingredient,
) {
  return DbIngredientCompanion.insert(
    recipeId: int.tryParse(ingredient.recipeId ?? '0') ?? 0,
    name: ingredient.name ?? '',
    amount: ingredient.weight ?? 0.0,
  );
}
