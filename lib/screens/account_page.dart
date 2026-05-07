import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../providers.dart';

typedef LogoutCallback = void Function(bool didLogout);

class AccountPage extends ConsumerStatefulWidget {
  final String name;
  final String email;
  final LogoutCallback onLogOut;

  const AccountPage({
    super.key,
    required this.onLogOut,
    required this.name,
    required this.email,
  });

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  Widget build(BuildContext context) {
    // Подписываемся на изменения в BookmarkManager
    final bookmarkManager = ref.watch(bookmarkProvider);
    final favorites = bookmarkManager.bookmarks;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40.0),
            buildProfile(),
            const SizedBox(height: 20.0),
            _buildFavoritesSection(favorites, bookmarkManager),
            const Divider(),
            buildMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(List<Recipe> favorites, BookmarkManager manager) {
    if (favorites.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No favorites yet. Tap the heart on vitamins to add them!'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Favorite Vitamins',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        // Используем ListView.builder для отображения избранного
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    item.imageUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(item.brand, style: const TextStyle(fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Удаление из избранного сразу обновит UI
                    manager.removeBookmark(item.id);
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildMenu() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('View Website'),
          onTap: () async {
            await launchUrl(Uri.parse('https://www.google.com/'));
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Log out', style: TextStyle(color: Colors.red)),
          onTap: () {
            widget.onLogOut(true);
          },
        )
      ],
    );
  }

  Widget buildProfile() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50.0,
          backgroundColor: Color(0xFFE8F5E9),
          child: Icon(Icons.person, size: 50, color: Color(0xFF2E7D32)),
        ),
        const SizedBox(height: 16.0),
        Text(
          widget.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          widget.email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'FitHerb Member',
            style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
