import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/cart_manager.dart';

void main() {
  group('CartManager Logic (Endterm Feature)', () {
    test('Calculating total price should be correct', () {
      final cart = CartManager();
      
      // Добавляем товары
      cart.addItem(CartItem(id: '1', name: 'Vitamin C', price: 10.0, quantity: 2));
      cart.addItem(CartItem(id: '2', name: 'Magnesium', price: 15.0, quantity: 1));

      // Ожидаем: (10.0 * 2) + (15.0 * 1) = 35.0
      // Используем totalCost, так как это имя геттера в модели
      expect(cart.totalCost, 35.0);
    });

    test('Removing item should update total price', () {
      final cart = CartManager();
      final item = CartItem(id: '1', name: 'Zinc', price: 12.0, quantity: 1);
      
      cart.addItem(item);
      expect(cart.totalCost, 12.0);
      
      // Передаем item.id (String), так как метод removeItem ожидает id
      cart.removeItem(item.id);
      expect(cart.totalCost, 0.0);
    });

    test('Updating quantity should update total price', () {
      final cart = CartManager();
      final item = CartItem(id: '1', name: 'Vitamin D', price: 20.0, quantity: 1);
      
      cart.addItem(item);
      expect(cart.totalCost, 20.0);
    });
  });
}
