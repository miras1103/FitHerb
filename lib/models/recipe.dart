import 'ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String brand;
  final List<Ingredient> ingredients;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.brand,
    this.ingredients = const [],
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Поддержка как внешнего API, так и нашего собственного формата сохранения
    final title = json['title'] as String? ?? 
        json['product_name'] as String? ??
        json['product_name_en'] as String? ??
        'Vitamin Supplement';

    final image = json['image'] as String? ??
        json['image_url'] as String? ??
        json['image_front_url'] as String? ??
        'https://via.placeholder.com/300x300?text=Vitamin';

    final id = json['id']?.toString() ?? 
        json['code']?.toString() ?? 
        json['_id']?.toString() ?? 
        '0';

    return Recipe(
      id: id,
      title: title,
      imageUrl: image,
      brand: json['brand'] as String? ?? json['brands'] as String? ?? 'FitHerb',
      ingredients: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imageUrl,
      'brand': brand,
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? brand,
    List<Ingredient>? ingredients,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}

class RecipeSearchResult {
  final int offset;
  final int number;
  final int totalResults;
  final List<Recipe> recipes;

  const RecipeSearchResult({
    required this.offset,
    required this.number,
    required this.totalResults,
    required this.recipes,
  });

  factory RecipeSearchResult.fromJson(Map<String, dynamic> json) {
    final results = json['foods'] as List<dynamic>? ?? [];

    return RecipeSearchResult(
      offset: json['currentPage'] as int? ?? 0,
      number: json['pageSize'] as int? ?? results.length,
      totalResults: json['totalHits'] as int? ?? results.length,
      recipes: results
          .whereType<Map<String, dynamic>>()
          .map(Recipe.fromJson)
          .toList(),
    );
  }
}
