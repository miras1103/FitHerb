import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../models/ingredient.dart';

class GroceriesPage extends ConsumerWidget {
  const GroceriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(repositoryProvider.notifier);

    return Scaffold(
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
                  ingredient.name ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${ingredient.weight ?? 0} g'),
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
