import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../components/components.dart';
import '../constants.dart';
import '../models/models.dart';
import '../providers.dart';
import 'checkout_page.dart';
import 'reminder_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantPage extends ConsumerStatefulWidget {
  final Restaurants restaurant;
  final CartManager cartManager;
  final OrderManager ordersManager;

  const RestaurantPage(
      {super.key,
      required this.restaurant,
      required this.cartManager,
      required this.ordersManager});

  @override
  ConsumerState<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends ConsumerState<RestaurantPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;
  static const double drawerWidth = 375.0;
  TimeOfDay? reminderTime;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReminder();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
            ? screenWidth * largeScreenPercentage
            : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  Future<void> _loadReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('hour');
    final minute = prefs.getInt('minute');

    if (hour != null && minute != null) {
      setState(() {
        reminderTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  void _sendReview() {
    if (_reviewController.text.trim().isEmpty) return;
    
    ref.read(reviewDaoProvider).sendReview(
      _reviewController.text,
      widget.restaurant.id,
    );
    _reviewController.clear();
    FocusScope.of(context).unfocus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
  }

  CustomScrollView _buildCustomScrollView() {
    final reviewsAsyncValue = ref.watch(reviewListProvider(widget.restaurant.id));

    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildNewReviewsSection(reviewsAsyncValue),
        _buildGridViewSection('Menu'),
      ],
    );
  }

  Widget _buildNewReviewsSection(AsyncValue<List<ProductReview>> reviewsAsyncValue) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendReview,
                  icon: const Icon(Icons.send, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),
            reviewsAsyncValue.when(
              data: (reviews) {
                if (reviews.isEmpty) {
                  return const Text('No reviews yet. Be the first!', 
                    style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
                }
                return Column(
                  children: reviews.map((review) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.email, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                            Text(DateFormat('dd.MM.yyyy').format(review.timestamp), 
                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(review.text),
                      ],
                    ),
                  )).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error loading reviews: $e'),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 300.0,
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
            child: Stack(
              children: [
                // УЛУЧШЕННЫЙ HERO: Теперь виджеты совпадают по типу с карточкой списка
                Hero(
                  tag: 'restaurant-image-${widget.restaurant.id}',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        widget.restaurant.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.store, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final restaurant = widget.restaurant;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(restaurant.name, style: textTheme.headlineLarge),
            Text(restaurant.address, style: textTheme.bodySmall),
            Text(restaurant.getRatingAndDistance(), style: textTheme.bodySmall),
            Text(restaurant.attributes, style: textTheme.labelSmall),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final time = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReminderPage()),
                );
                if (time != null) {
                  setState(() {
                    reminderTime = time;
                  });
                }
              },
              child: const Text('Set Reminder'),
            ),
            if (reminderTime != null) ...[
              const SizedBox(height: 10),
              Text(
                'Reminder: ${reminderTime!.format(context)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.restaurant.items[index];
    return InkWell(
      onTap: () => _showBottomSheet(item),
      child: RestaurantItem(item: item),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.restaurant.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(title),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(Item item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => ItemDetails(
        item: item,
        cartManager: widget.cartManager,
        quantityUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
          child: CheckoutPage(
        cartManager: widget.cartManager,
        didUpdate: () {
          setState(() {});
        },
        onSubmit: (order) {
          widget.ordersManager.addOrder(order);
          context.pop();
          context.go('/${YummyTab.orders.value}');
        },
      )),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: openDrawer,
      tooltip: 'Cart',
      icon: const Icon(Icons.shopping_cart),
      label: Text('${widget.cartManager.items.length} Items in cart'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }
}
