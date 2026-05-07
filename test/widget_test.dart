import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/main.dart';
import 'package:yummy/providers.dart';
import 'package:yummy/api/spoonacular_service.dart';

void main() {
  testWidgets('Yummy app smoke test', (WidgetTester tester) async {
    // Настройка мока SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();
    final service = SpoonacularService();

    // Запуск приложения внутри ProviderScope с необходимыми переопределениями
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPrefProvider.overrideWithValue(sharedPrefs),
          serviceProvider.overrideWithValue(service),
        ],
        child: const Yummy(),
      ),
    );

    // Проверяем, что приложение отрендерилось (находим сам виджет Yummy)
    expect(find.byType(Yummy), findsOneWidget);
  });
}
