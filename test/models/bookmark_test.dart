import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/bookmark_manager.dart';

// Создаем простую заглушку для тестов логики
class FakeBookmarkManager extends BookmarkManager {
  FakeBookmarkManager() : super(null, firestore: null);

  @override
  void _listenToFavorites() {
    // Переопределяем, чтобы не было обращения к Firebase в тестах
  }
}

void main() {
  group('BookmarkManager Endterm Logic', () {
    late FakeBookmarkManager manager;

    setUp(() {
      manager = FakeBookmarkManager();
    });

    test('generateSafeId creates clean and consistent IDs for Firebase', () {
      // Тестируем логику очистки ID для Firestore (Endterm Feature)
      final id1 = manager.generateSafeId('NOW Foods', 'Vitamin D-3');
      expect(id1, 'now_foods_vitamin_d_3');

      final id2 = manager.generateSafeId('Brand!!!', 'Product @#% Name');
      expect(id2, 'brand____product_____name');

      final id3 = manager.generateSafeId('  Solgar  ', '  Zinc  ');
      expect(id3, 'solgar_zinc');
    });

    test('isFavorite starts with an empty list', () {
      expect(manager.isFavorite('Any', 'Any'), isFalse);
    });
  });
}
