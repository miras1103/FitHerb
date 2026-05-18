import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../providers.dart';
import 'cart_control.dart';

class ItemDetails extends ConsumerStatefulWidget {
  final Item item;
  final CartManager cartManager;
  final void Function() quantityUpdated;

  const ItemDetails({
    Key? key,
    required this.item,
    required this.cartManager,
    required this.quantityUpdated,
  }) : super(key: key);

  @override
  ConsumerState<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<ItemDetails> {
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _sendReview() {
    if (_reviewController.text.trim().isEmpty) return;
    
    final productId = widget.item.name; 

    ref.read(reviewDaoProvider).sendReview(
      _reviewController.text,
      productId,
    );
    
    _reviewController.clear();
    FocusScope.of(context).unfocus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorTheme = Theme.of(context).colorScheme;
    
    final reviewsAsyncValue = ref.watch(reviewListProvider(widget.item.name));

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.item.name, style: textTheme.headlineMedium),
            const SizedBox(height: 16.0),
            _mostLikedBadge(colorTheme),
            const SizedBox(height: 16.0),
            Text(widget.item.description),
            const SizedBox(height: 16.0),
            _itemImage(widget.item.imageUrl),
            const SizedBox(height: 16.0),
            _addToCartControl(widget.item),
            
            const Divider(height: 32),
            
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: InputDecoration(
                      hintText: 'Add a review...',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
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
                  return const Text('No reviews for this product yet.', 
                    style: TextStyle(color: Colors.grey, fontSize: 13));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(r.email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                              Text(DateFormat('dd.MM.yyyy').format(r.timestamp), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          Text(r.text, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _mostLikedBadge(ColorScheme colorTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.all(4.0),
          color: colorTheme.onPrimary,
          child: const Text('#1 Most Liked')),
    );
  }

  Widget _itemImage(String imageUrl) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          // ИСПРАВЛЕНО: Используем AssetImage вместо NetworkImage, так как это локальные ресурсы
          image: AssetImage(imageUrl),
          fit: BoxFit.contain, // Используем contain, чтобы картинка витамина не обрезалась
        ),
      ),
    );
  }

  Widget _addToCartControl(Item item) {
    return CartControl(
      addToCart: (number) {
        const uuid = Uuid();
        final uniqueId = uuid.v4();
        final cartItem = CartItem(
            id: uniqueId, name: item.name, price: item.price, quantity: number);
        setState(() {
          widget.cartManager.addItem(cartItem);
          widget.quantityUpdated();
        });
        Navigator.pop(context);
      },
    );
  }
}
