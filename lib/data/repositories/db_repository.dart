import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/recipe_db.dart';
import '../models/current_recipe_data.dart';
import '../../models/models.dart';
import '../../models/ingredient.dart';
import 'repository.dart';

class DBRepository extends Notifier<CurrentRecipeData> implements Repository {
  final RecipeDatabase recipeDatabase;
  final RecipeDao _recipeDao;
  final IngredientDao _ingredientDao;

  // Основной конструктор вызывает внутренний для надежной инициализации полей
  DBRepository({RecipeDatabase? recipeDatabase})
      : this._internal(recipeDatabase ?? RecipeDatabase());

  DBRepository._internal(RecipeDatabase db)
      : recipeDatabase = db,
        _recipeDao = db.recipeDao,
        _ingredientDao = db.ingredientDao;

  @override
  CurrentRecipeData build() {
    return const CurrentRecipeData();
  }

  Future<void> init() async {
    final recipes = await findAllRecipes();
    final dbIngs = await _ingredientDao.findAllIngredients();
    final ingredients = dbIngs.map(dbIngredientToIngredient).toList();
    
    state = state.copyWith(
      currentRecipes: recipes,
      currentIngredients: ingredients,
    );
  }

  @override
  void close() => recipeDatabase.close();

  @override
  Future<List<Recipe>> findAllRecipes() async {
    final dbRecipes = await _recipeDao.findAllRecipes();
    final recipes = <Recipe>[];
    for (final dbR in dbRecipes) {
      final ingredients = await findRecipeIngredients(dbR.id.toString());
      recipes.add(dbRecipeToModelRecipe(dbR, ingredients));
    }
    return recipes;
  }

  @override
  Stream<List<Recipe>> watchAllRecipes() => _recipeDao.watchAllRecipes();

  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    return _ingredientDao.watchAllIngredients().map((dbIngredients) {
      return dbIngredients.map(dbIngredientToIngredient).toList();
    });
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return _ingredientDao.findAllIngredients().then((list) {
      return list.map(dbIngredientToIngredient).toList();
    });
  }

  Future<List<Ingredient>> findRecipeIngredients(String recipeId) {
    final id = int.tryParse(recipeId) ?? 0;
    return _ingredientDao.findRecipeIngredients(id).then((list) {
      return list.map(dbIngredientToIngredient).toList();
    });
  }

  @override
  void insertRecipe(Recipe recipe) {
    if (state.currentRecipes.any((r) => r.id == recipe.id)) return;

    final dbRecipe = recipeToInsertableDbRecipe(recipe);
    _recipeDao.insertRecipe(dbRecipe).then((_) {
      for (final ingredient in recipe.ingredients) {
        final dbIng = ingredientToInsertableDbIngredient(
          ingredient.copyWith(recipeId: int.tryParse(recipe.id)),
        );
        _ingredientDao.insertIngredient(dbIng);
      }
      _updateState();
    });
  }

  @override
  void deleteRecipe(Recipe recipe) {
    final id = int.tryParse(recipe.id) ?? 0;
    _recipeDao.deleteRecipe(id).then((_) {
      _ingredientDao.deleteRecipeIngredients(id);
      _updateState();
    });
  }

  @override
  void insertIngredients(List<Ingredient> ingredients) {
    for (final ingredient in ingredients) {
      final dbIng = ingredientToInsertableDbIngredient(ingredient);
      _ingredientDao.insertIngredient(dbIng);
    }
    _updateState();
  }

  @override
  void deleteIngredient(Ingredient ingredient) {
    if (ingredient.id != null) {
      _ingredientDao.deleteIngredient(ingredient.id!).then((_) {
        _updateState();
      });
    }
  }

  @override
  void deleteIngredients(List<Ingredient> ingredients) {
    for (final ingredient in ingredients) {
      if (ingredient.id != null) {
        _ingredientDao.deleteIngredient(ingredient.id!);
      }
    }
    _updateState();
  }

  @override
  void deleteRecipeIngredients(String recipeId) {
    final id = int.tryParse(recipeId) ?? 0;
    _ingredientDao.deleteRecipeIngredients(id).then((_) {
      _updateState();
    });
  }

  void _updateState() async {
    final recipes = await findAllRecipes();
    final dbIngs = await _ingredientDao.findAllIngredients();
    final ingredients = dbIngs.map(dbIngredientToIngredient).toList();
    state = state.copyWith(
      currentRecipes: recipes,
      currentIngredients: ingredients,
    );
  }
}
