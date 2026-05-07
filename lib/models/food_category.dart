class FoodCategory {
  String name;
  int numberOfRestaurants;
  String imageUrl;

  FoodCategory(this.name, this.numberOfRestaurants, this.imageUrl);
}

List<FoodCategory> categories = [
  FoodCategory('Protein', 25, 'assets/categories/protein.jpg'),
  FoodCategory('Vitamins', 18, 'assets/categories/vitamins.jpg'),
  FoodCategory('Creatine', 12, 'assets/categories/creatine.jpg'),
  FoodCategory('Pre-Workout', 15, 'assets/categories/preworkout.jpg'),
  FoodCategory('BCAA', 10, 'assets/categories/bcaa.jpg'),
  FoodCategory('Mass Gainers', 11, 'assets/categories/gainer.jpg'),
  FoodCategory('Omega-3', 9, 'assets/categories/omega3.jpg'),
  FoodCategory('Amino Acids', 13, 'assets/categories/amin.jpg'),
  FoodCategory('Energy Drinks', 20, 'assets/categories/energy.jpg'),
  FoodCategory('Minerals', 16, 'assets/categories/minerals.jpg'),
];
