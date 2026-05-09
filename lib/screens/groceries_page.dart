import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/models.dart';

class GroceriesPage extends ConsumerWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(repositoryProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries'),
      ),
      body: StreamBuilder<List<Ingredient>>(
        stream: repository.watchAllIngredients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final ingredients = snapshot.data ?? [];
          if (ingredients.isEmpty) {
            return const Center(
              child: Text(
                'No Groceries yet!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ingredients.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  ingredient.name ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${ingredient.amount ?? 0.0} g'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => repository.deleteIngredient(ingredient),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
