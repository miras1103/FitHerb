import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:yummy/models/order_manager.dart';
import 'package:yummy/models/cart_manager.dart';

void main() {
  group('Order Model (Endterm Feature)', () {
    test('getFormattedSegment returns correct delivery type', () {
      final orderSelfPick = Order(
        selectedSegment: {1},
        selectedTime: null,
        selectedDate: null,
        name: 'Test',
        items: [],
      );
      final orderDelivery = Order(
        selectedSegment: {0},
        selectedTime: null,
        selectedDate: null,
        name: 'Test',
        items: [],
      );

      expect(orderSelfPick.getFormattedSegment(), 'Self Pick Up');
      expect(orderDelivery.getFormattedSegment(), 'Delivery');
    });

    test('getFormattedName returns name or first item name', () {
      final orderWithName = Order(
        selectedSegment: {0},
        selectedTime: null,
        selectedDate: null,
        name: 'My Custom Order',
        items: [CartItem(id: '1', name: 'Vitamin C', price: 10.0, quantity: 1)],
      );

      final orderNoName = Order(
        selectedSegment: {0},
        selectedTime: null,
        selectedDate: null,
        name: '',
        items: [CartItem(id: '1', name: 'Vitamin D', price: 15.0, quantity: 1)],
      );

      expect(orderWithName.getFormattedName(), 'My Custom Order');
      expect(orderNoName.getFormattedName(), 'Vitamin D');
    });

    test('getFormattedTime returns ASAP when null', () {
      final orderAsap = Order(
        selectedSegment: {0},
        selectedTime: null,
        selectedDate: null,
        name: 'Test',
        items: [],
      );
      
      final orderSpecificTime = Order(
        selectedSegment: {0},
        selectedTime: const TimeOfDay(hour: 14, minute: 30),
        selectedDate: null,
        name: 'Test',
        items: [],
      );

      expect(orderAsap.getFormattedTime(), 'ASAP');
      expect(orderSpecificTime.getFormattedTime(), '14:30');
    });
  });
}
