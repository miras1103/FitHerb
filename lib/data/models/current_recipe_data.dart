import '../../models/recipe.dart';
import '../../models/ingredient.dart';

class CurrentRecipeData {
  final List<Recipe> currentRecipes;
  final List<Ingredient> currentIngredients;

  const CurrentRecipeData({
    this.currentRecipes = const [],
    this.currentIngredients = const [],
  });

  CurrentRecipeData copyWith({
    List<Recipe>? currentRecipes,
    List<Ingredient>? currentIngredients,
  }) {
    return CurrentRecipeData(
      currentRecipes: currentRecipes ?? this.currentRecipes,
      currentIngredients: currentIngredients ?? this.currentIngredients,
    );
  }
}
