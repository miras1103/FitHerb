import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cart_manager.dart';

class Order {
  final String? id;
  final Set<int> selectedSegment;
  final TimeOfDay? selectedTime;
  final DateTime? selectedDate;
  final String name;
  final List<CartItem> items;
  final DateTime? timestamp;

  Order({
    this.id,
    required this.selectedSegment,
    required this.selectedTime,
    required this.selectedDate,
    required this.name,
    required this.items,
    this.timestamp,
  });

  String getFormattedSegment() {
    if (selectedSegment.contains(1)) return 'Self Pick Up';
    return 'Delivery';
  }

  String getFormattedTime() {
    if (selectedTime == null) return 'ASAP';
    final hour = selectedTime!.hour.toString().padLeft(2, '0');
    final minute = selectedTime!.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String getFormattedDate() {
    // Если дата доставки не выбрана, используем дату создания заказа
    final displayDate = selectedDate ?? timestamp;
    if (displayDate == null) return 'Today';
    return DateFormat('MMM d, yyyy').format(displayDate);
  }

  String getFormattedName() {
    if (name.trim().isNotEmpty) return name;
    // Если имя не введено, показываем название первого товара
    if (items.isNotEmpty) return items.first.name;
    return 'Order';
  }

  String getFormattedOrderInfo() {
    final segmentString = getFormattedSegment();
    final nameStr = getFormattedName();
    final timeString = getFormattedTime();
    final dateString = getFormattedDate();

    return '$nameStr | $dateString | $timeString | $segmentString';
  }

  factory Order.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};
    
    debugPrint('--- Parsing Order ${snapshot.id} ---');

    final List<CartItem> items = [];
    if (data['items'] is List) {
      for (var item in data['items']) {
        items.add(CartItem(
          id: (item['id'] ?? '').toString(),
          name: (item['name'] ?? '').toString(),
          price: (item['price'] as num? ?? 0.0).toDouble(),
          quantity: (item['quantity'] as num? ?? 1).toInt(),
        ));
      }
    }

    TimeOfDay? time;
    final rawTime = data['selectedTime'];
    if (rawTime is String && rawTime.contains(':')) {
      try {
        final parts = rawTime.split(':');
        time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {}
    }

    DateTime? date;
    if (data['selectedDate'] is Timestamp) {
      date = (data['selectedDate'] as Timestamp).toDate();
    }

    final Set<int> segment = {};
    if (data['selectedSegment'] is List) {
      for (var e in data['selectedSegment']) {
        segment.add((e as num).toInt());
      }
    }
    if (segment.isEmpty) segment.add(0);

    return Order(
      id: snapshot.id,
      selectedSegment: segment,
      selectedTime: time,
      selectedDate: date,
      name: (data['name'] ?? '').toString(),
      items: items,
      timestamp: data['timestamp'] is Timestamp ? (data['timestamp'] as Timestamp).toDate() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedSegment': selectedSegment.toList(),
      'selectedTime': selectedTime != null ? '${selectedTime!.hour}:${selectedTime!.minute}' : null,
      'selectedDate': selectedDate != null ? Timestamp.fromDate(selectedDate!) : null,
      'name': name,
      'items': items.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
      }).toList(),
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

class OrderManager {
  final List<Order> _orders = [];
  List<Order> get orders => _orders;
  void addOrder(Order order) => _orders.add(order);
  void removeOrder(Order order) => _orders.remove(order);
  int get totalOrders => _orders.length;
}
