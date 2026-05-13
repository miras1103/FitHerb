import '../models/models.dart';

// ExploreData serves as a data container that holds
//list of restaurants, food categories, and friend posts.
class ExploreData {
  final List<Restaurants> restaurants;
  final List<FoodCategory> categories;
  final List<Post> friendPosts;

  ExploreData(this.restaurants, this.categories, this.friendPosts);
}

// Mock Yummy service that grabs sample data to mock up a food app request/response
class MockYummyService {
  // Batch request that gets both today recipes and friend's feed
  Future<ExploreData> getExploreData() async {
    // УВЕЛИЧИВАЕМ ЗАДЕРЖКУ ДО 1 СЕКУНД, чтобы ты точно увидел Lottie (Chapter Final)
    await Future.delayed(const Duration(seconds: 1));
    
    final restaurants = await _getRestaurants();
    final categories = await _getCategories();
    final friendPosts = await _getFriendFeed();

    return ExploreData(restaurants, categories, friendPosts);
  }

  // Get sample food categories to display in ui
  Future<List<FoodCategory>> _getCategories() async {
    return categories;
  }

  // Get the friend posts to display in ui
  Future<List<Post>> _getFriendFeed() async {
    return posts;
  }

  // Get the restaurants to display in ui
  Future<List<Restaurants>> _getRestaurants() async {
    return restaurants;
  }
}
