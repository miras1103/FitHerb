import '../../models/models.dart';
import '../../models/ingredient.dart';

abstract class Repository {
  Future<List<Recipe>> findAllRecipes();
  Stream<List<Recipe>> watchAllRecipes();

  void insertRecipe(Recipe recipe);
  void deleteRecipe(Recipe recipe);

  Future<List<Ingredient>> findAllIngredients();
  Stream<List<Ingredient>> watchAllIngredients();

  void insertIngredients(List<Ingredient> ingredients);
  void deleteIngredient(Ingredient ingredient);
  void deleteIngredients(List<Ingredient> ingredients);
  void deleteRecipeIngredients(String recipeId);

  void close();
}
