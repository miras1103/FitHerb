import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/main.dart';
import 'package:yummy/providers.dart';
import 'package:yummy/api/spoonacular_service.dart';
import 'package:yummy/models/user_dao.dart';
import 'package:mockito/mockito.dart';

class FakeUserDao extends ChangeNotifier implements UserDao {
  @override
  bool isLoggedIn() => false;
  @override
  String? userId() => null;
  @override
  String? email() => 'fitherb@health.com';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('FitHerb app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    final service = SpoonacularService();
    final fakeUserDao = FakeUserDao();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefProvider.overrideWithValue(sharedPrefs),
          serviceProvider.overrideWithValue(service),
          userDaoProvider.overrideWith((ref) => fakeUserDao),
        ],
        child: const Yummy(),
      ),
    );

    // Проверяем, что приложение FitHerb отрендерилось
    expect(find.byType(Yummy), findsOneWidget);
  });
}
