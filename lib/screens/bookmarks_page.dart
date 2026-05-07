import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/recipe.dart';
import 'recipe_details_page.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(repositoryProvider.notifier);

    return Scaffold(
      body: StreamBuilder<List<Recipe>>(
        stream: repository.watchAllRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(
              child: Text('No Bookmarks yet!', 
                style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    recipe.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(recipe.title, 
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(recipe.brand, 
                  maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeDetailsPage(recipe: recipe),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => repository.deleteRecipe(recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
