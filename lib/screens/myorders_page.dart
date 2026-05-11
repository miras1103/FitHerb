import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers.dart';

class MyOrdersPage extends ConsumerWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final ordersAsyncValue = ref.watch(orderListProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('My Orders', 
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ordersAsyncValue.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 100, color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  Text('You haven\'t placed any orders yet', 
                    style: textTheme.bodyLarge?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderCard(order: orders[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  double _calculateTotal() {
    return order.items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = _calculateTotal();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${order.id?.substring(0, 8).toUpperCase() ?? 'N/A'}',
                      style: textTheme.labelLarge?.copyWith(color: Colors.green.shade800, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(order.getFormattedDate(), style: textTheme.bodySmall),
                  ],
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: textTheme.titleLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.shopping_basket_outlined, size: 18, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.getFormattedOrderInfo(),
                    style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.shade50.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 14, color: Colors.green),
                const SizedBox(width: 6),
                Text('Order Confirmed', style: textTheme.labelSmall?.copyWith(color: Colors.green.shade700)),
                const Spacer(),
                const Icon(Icons.chevron_right, size: 16, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
