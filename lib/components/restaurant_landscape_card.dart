import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers.dart';

class RestaurantLandscapeCard extends ConsumerWidget {
  final Restaurants restaurant;
  final Function() onTap;

  const RestaurantLandscapeCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final isFavorited = bookmarkManager.isBookmarked(restaurant.id);
    
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
        
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(8.0)),
            child: AspectRatio(
                aspectRatio: 2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      restaurant.imageUrl, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: IconButton(
                        icon: Icon(isFavorited
                            ? Icons.favorite
                            : Icons.favorite_border),
                        iconSize: 30.0,
                        color: Colors.red[400],
                        onPressed: () {
                          final recipe = Recipe(
                            id: restaurant.id,
                            imageUrl: restaurant.imageUrl,
                            title: restaurant.name,
                            brand: restaurant.attributes,
                          );
                          bookmarkManager.toggleBookmark(recipe);
                        },
                      ),
                    ),
                  ],
                )
              ),
          ),
          ListTile(
            title: Text(restaurant.name, style: textTheme.titleSmall),
            subtitle: Text(restaurant.attributes,
                maxLines: 1, style: textTheme.bodySmall),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
