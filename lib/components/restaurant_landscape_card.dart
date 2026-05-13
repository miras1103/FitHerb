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
    final isFavorited = bookmarkManager.isFavorite(restaurant.attributes, restaurant.name);
    
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
                    // ДОБАВЛЕНО: Hero animation для плавного перехода изображения
                    Hero(
                      tag: 'restaurant-image-${restaurant.id}',
                      child: Image.asset(
                        restaurant.imageUrl, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border),
                          iconSize: 28.0,
                          // Если в избранном - красный, если нет - серый
                          color: isFavorited ? Colors.red : Colors.grey[600],
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
