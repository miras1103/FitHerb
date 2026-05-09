import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../models/ingredient.dart';
import '../models/current_recipe_data.dart';
import 'repository.dart';

class MemoryRepository extends Notifier<CurrentRecipeData>
    implements Repository {
  StreamController<List<Recipe>>? _recipeStreamController;
  StreamController<List<Ingredient>>? _ingredientStreamController;

  @override
  CurrentRecipeData build() {
    _recipeStreamController = StreamController<List<Recipe>>.broadcast();
    _ingredientStreamController = 
        StreamController<List<Ingredient>>.broadcast();

    ref.onDispose(() {
      _recipeStreamController?.close();
      _ingredientStreamController?.close();
    });

    return const CurrentRecipeData();
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() {
    _recipeStreamController ??= StreamController<List<Recipe>>.broadcast();
    return _recipeStreamController!.stream;
  }

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    _ingredientStreamController ??= 
        StreamController<List<Ingredient>>.broadcast();
    return _ingredientStreamController!.stream;
  }

  @override
  Future<List<Recipe>> findAllRecipes() {
    return Future.value(state.currentRecipes);
  }

  @override
  void insertRecipe(Recipe recipe) {
    if (state.currentRecipes.contains(recipe)) {
      return;
    }
    state = state.copyWith(currentRecipes: [...state.currentRecipes, recipe]);
    _recipeStreamController?.sink.add(state.currentRecipes);
  }

  @override
  void deleteRecipe(Recipe recipe) {
    final updatedList = [...state.currentRecipes];
    updatedList.remove(recipe);
    state = state.copyWith(currentRecipes: updatedList);
    _recipeStreamController?.sink.add(state.currentRecipes);
    deleteRecipeIngredients(recipe.id);
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return Future.value(state.currentIngredients);
  }

  @override
  void insertIngredients(List<Ingredient> ingredients) {
    state = state.copyWith(
      currentIngredients: [...state.currentIngredients, ...ingredients],
    );
    _ingredientStreamController?.sink.add(state.currentIngredients);
  }

  @override
  void deleteIngredient(Ingredient ingredient) {
    final updatedList = [...state.currentIngredients];
    updatedList.remove(ingredient);
    state = state.copyWith(currentIngredients: updatedList);
    _ingredientStreamController?.sink.add(state.currentIngredients);
  }

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    final updatedList = [...state.currentIngredients];
    updatedList.removeWhere((ingredient) => ingredients.contains(ingredient));
    state = state.copyWith(currentIngredients: updatedList);
    _ingredientStreamController?.sink.add(state.currentIngredients);
  }

  @override
  void deleteRecipeIngredients(String recipeId) {
    final id = int.tryParse(recipeId);
    final updatedList = [...state.currentIngredients];
    updatedList.removeWhere((ingredient) => ingredient.recipeId == id);
    state = state.copyWith(currentIngredients: updatedList);
    _ingredientStreamController?.sink.add(state.currentIngredients);
  }

  @override
  void close() {
    _recipeStreamController?.close();
    _ingredientStreamController?.close();
  }
}
