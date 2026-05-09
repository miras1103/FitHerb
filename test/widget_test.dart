import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/main.dart';
import 'package:yummy/providers.dart';
import 'package:yummy/api/spoonacular_service.dart';
import 'package:yummy/models/user_dao.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Создаем простой фейковый класс для UserDao, чтобы избежать инициализации Firebase
class FakeUserDao extends ChangeNotifier implements UserDao {
  @override
  bool isLoggedIn() => false;
  
  @override
  String? userId() => null;
  
  @override
  String? email() => 'test@test.com';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('Yummy app smoke test', (WidgetTester tester) async {
    // Настройка мока SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    final service = SpoonacularService();
    final fakeUserDao = FakeUserDao();

    // Запуск приложения внутри ProviderScope с необходимыми переопределениями
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefProvider.overrideWithValue(sharedPrefs),
          serviceProvider.overrideWithValue(service),
          // Переопределяем userDaoProvider нашим фейком, чтобы не было ошибки Firebase
          userDaoProvider.overrideWith((ref) => fakeUserDao),
        ],
        child: const Yummy(),
      ),
    );

    // Проверяем, что приложение отрендерилось
    expect(find.byType(Yummy), findsOneWidget);
  });
}
