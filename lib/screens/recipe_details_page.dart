import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../api/spoonacular_service.dart';
import '../models/models.dart';
import '../providers.dart';

class RecipeDetailsPage extends ConsumerStatefulWidget {
  const RecipeDetailsPage({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  ConsumerState<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends ConsumerState<RecipeDetailsPage> {
  final SpoonacularService _service = SpoonacularService();
  late Future<Map<String, dynamic>> _detailsFuture;
  Map<String, dynamic>? _currentDetails;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detailsFuture = _service.queryRecipe(widget.recipe.id);
  }

  @override
  void dispose() {
    _service.close();
    _reviewController.dispose();
    super.dispose();
  }

  void _toggleBookmark() {
    final manager = ref.read(bookmarkProvider);
    manager.toggleBookmark(widget.recipe);
  }

  void _sendReview() {
    if (_reviewController.text.trim().isEmpty) return;
    
    ref.read(reviewDaoProvider).sendReview(
      _reviewController.text,
      widget.recipe.id,
    );
    _reviewController.clear();
    FocusScope.of(context).unfocus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review submitted!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkManager.isFavorite(widget.recipe.brand, widget.recipe.title);
    final reviewsAsyncValue = ref.watch(reviewListProvider(widget.recipe.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove from favorites' : 'Add to favorites',
            icon: Icon(
              isBookmarked ? Icons.favorite : Icons.favorite_border,
              color: isBookmarked ? Colors.red : null,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading details: ${snapshot.error}'),
            );
          }

          _currentDetails = snapshot.data ?? {};
          final details = _currentDetails!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildHeader(details),
              const SizedBox(height: 16),
              _buildImage(details),
              const SizedBox(height: 16),
              _buildIngredients(details),
              const SizedBox(height: 16),
              _buildNutrients(details),
              const Divider(height: 32),
              _buildReviewInput(),
              const SizedBox(height: 16),
              _buildReviewsList(reviewsAsyncValue),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Write a Review',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _reviewController,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _sendReview,
              icon: const Icon(Icons.send, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewsList(AsyncValue<List<ProductReview>> reviewsAsyncValue) {
    return reviewsAsyncValue.when(
      data: (reviews) {
        if (reviews.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No reviews yet. Be the first to review!',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Reviews (${reviews.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.email,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy').format(review.timestamp),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Could not load reviews. Please try again later.', 
          style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> details) {
    final brand = details['brands'] as String? ?? widget.recipe.brand;
    final category = details['categories'] as String? ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details['product_name'] as String? ?? widget.recipe.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (brand.isNotEmpty)
              Text(
                'Brand: $brand',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            if (category.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Categories: $category',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Map<String, dynamic> details) {
    final imageUrl = details['image_url'] as String? ?? widget.recipe.imageUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        height: 250,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.medication, size: 100),
      ),
    );
  }

  Widget _buildIngredients(Map<String, dynamic> details) {
    final ingredients = details['ingredients_text'] as String? ??
        details['ingredients_text_en'] as String? ??
        '';
    if (ingredients.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(ingredients),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrients(Map<String, dynamic> details) {
    final nutrients = details['nutriments'] as Map<String, dynamic>? ?? {};
    final List<Widget> nutrientTiles = [];

    nutrients.forEach((key, value) {
      if (value is num && _isInterestingNutrient(key)) {
        final unit = nutrients['${key}_unit'] ?? '';
        nutrientTiles.add(ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(_formatNutrientName(key)),
          trailing: Text('$value $unit'),
        ));
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nutrition and Vitamins',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (nutrientTiles.isEmpty) const Text('No nutrient data available'),
            ...nutrientTiles,
          ],
        ),
      ),
    );
  }

  bool _isInterestingNutrient(String key) {
    const interesting = [
      'vitamin', 'calcium', 'iron', 'magnesium', 'zinc', 'potassium',
      'proteins', 'energy', 'fat', 'carbohydrates'
    ];
    return interesting.any(key.toLowerCase().contains);
  }

  String _formatNutrientName(String key) {
    String name = key.replaceAll('-', ' ').replaceAll('_', ' ');
    if (name.length < 2) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
