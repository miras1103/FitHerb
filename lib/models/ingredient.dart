class Ingredient {
  final int? id;
  final String? recipeId;
  final String? name;
  final double? weight;

  Ingredient({
    this.id,
    this.recipeId,
    this.name,
    this.weight,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          recipeId == other.recipeId &&
          name == other.name &&
          weight == other.weight;

  @override
  int get hashCode => id.hashCode ^ recipeId.hashCode
  ^ name.hashCode ^ weight.hashCode;

  Ingredient copyWith({
    int? id,
    String? recipeId,
    String? name,
    double? weight,
  }) {
    return Ingredient(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      weight: weight ?? this.weight,
    );
  }
}
