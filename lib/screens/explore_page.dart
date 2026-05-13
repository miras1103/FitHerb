import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
              // Добавляем анимацию появления для секций
              SlideFadeTransition(
                delay: 100,
                child: RestaurantSection(
                  restaurants: restaurants,
                  cartManager: cartManager,
                  orderManager: orderManager,
                ),
              ),
              SlideFadeTransition(
                delay: 300,
                child: PostSection(posts: posts),
              ),
              SlideFadeTransition(
                delay: 500,
                child: CategorySection(categories: categories),
              ),
            ],
          );
        } else {
          // ИСПОЛЬЗУЕМ LOTTIE АНИМАЦИЮ ДЛЯ ЗАГРУЗКИ (Chapter Final)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_t9gkkhz4.json', // Анимация здорового питания/листа
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                const Text('Growing your wellness...', 
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
              ],
            ),
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

// Вспомогательный виджет для анимации Slide + Fade (Chapter Final)
class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final int delay;

  const SlideFadeTransition({super.key, required this.child, required this.delay});

  @override
  State<SlideFadeTransition> createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: widget.child,
      ),
    );
  }
}
