import 'package:cloud_firestore/cloud_firestore.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _showEditProfileDialog(Map<String, dynamic>? currentData) {
    _firstNameController.text = currentData?['firstName'] ?? widget.name;
    _lastNameController.text = currentData?['lastName'] ?? '';
    _ageController.text = (currentData?['age'] ?? '').toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final firstName = _firstNameController.text.trim();
              if (firstName.isNotEmpty) {
                await ref.read(userDaoProvider).updateProfile(
                      firstName: firstName,
                      lastName: _lastNameController.text.trim(),
                      age: int.tryParse(_ageController.text.trim()) ?? 0,
                    );
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final favorites = bookmarkManager.bookmarks;
    final isLoading = bookmarkManager.isLoading;
    final profileStream = ref.watch(userDaoProvider).getProfileStream();
    final ordersAsyncValue = ref.watch(orderListProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: StreamBuilder<DocumentSnapshot>(
        stream: profileStream,
        builder: (context, snapshot) {
          final profileData = snapshot.data?.data() as Map<String, dynamic>?;
          final ordersCount = ordersAsyncValue.value?.length ?? 0;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildPremiumHeader(profileData, ordersCount, favorites.length),
                    const SizedBox(height: 20.0),
                    _buildFavoritesSection(favorites, bookmarkManager, isLoading),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Divider(),
                    ),
                    _buildMenu(profileData),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPremiumHeader(Map<String, dynamic>? data, int ordersCount, int favCount) {
    final firstName = data?['firstName'] ?? widget.name;
    final lastName = data?['lastName'] ?? '';
    final age = data?['age'];

    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade100, width: 4),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green.shade50,
                  child: Icon(Icons.person, size: 50, color: Colors.green.shade700),
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.green.shade700,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  onPressed: () => _showEditProfileDialog(data),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$firstName $lastName',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.email,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          if (age != null && age != 0)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Age: $age', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderStat('Orders', ordersCount.toString()),
              const SizedBox(width: 40),
              _buildHeaderStat('Favorites', favCount.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildFavoritesSection(
      List<Recipe> favorites, BookmarkManager manager, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Text(
            'Favorite Vitamins',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (favorites.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Text('No favorites yet. Tap the heart on vitamins to add them!'),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildItemImage(item.imageUrl),
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item.brand, style: const TextStyle(fontSize: 12)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    onPressed: () => manager.removeBookmark(item.id),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildItemImage(String imageUrl) {
    return Image(
      image: imageUrl.startsWith('http') ? NetworkImage(imageUrl) : AssetImage(imageUrl) as ImageProvider,
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
    );
  }

  Widget _buildMenu(Map<String, dynamic>? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildMenuTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () => _showEditProfileDialog(data),
          ),
          _buildMenuTile(
            icon: Icons.language_outlined,
            title: 'View Website',
            onTap: () async {
              await launchUrl(Uri.parse('https://github.com/miras1103/FitHerb'));
            },
          ),
          _buildMenuTile(
            icon: Icons.logout_outlined,
            title: 'Log out',
            color: Colors.redAccent,
            onTap: () => widget.onLogOut(true),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Colors.green).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? Colors.green.shade700, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: color)),
      trailing: const Icon(Icons.chevron_right, size: 20),
    );
  }
}
