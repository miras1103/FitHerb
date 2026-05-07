import 'package:flutter/material.dart';
import '../api/mock_yummy_service.dart';
import '../components/components.dart';
import '../models/models.dart';
import 'search_page.dart';

class ExplorePage extends StatelessWidget {
  final mockService = MockYummyService();
  final CartManager cartManager;
  final OrderManager orderManager;

  ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final restaurants = snapshot.data?.restaurants ?? [];
          final categories = snapshot.data?.categories ?? [];
          final posts = snapshot.data?.friendPosts ?? [];

          return ListView(
            padding: const EdgeInsets.only(top: 8),
            children: [
              // Search bar entry point
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CompactSearchWidget(),
              ),
              RestaurantSection(
                restaurants: restaurants,
                cartManager: cartManager,
                orderManager: orderManager,
              ),
              PostSection(posts: posts),
              CategorySection(categories: categories),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class CompactSearchWidget extends StatelessWidget {
  const CompactSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.search),
        title: const Text('Search vitamins & videos'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchPage(),
            ),
          );
        },
      ),
    );
  }
}
