import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/components/ingredient_card.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Widget _buildWrappedWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [
          child,
        ],
      ),
    ),
  );
}

void main() {
  const mockProductName = 'Vitamin C Capsules';

  group('ProductCard (IngredientCard) Widget', () {
    testWidgets('ProductCard can build with FitHerb data', (WidgetTester tester) async {
      await tester.pumpWidget(
        _buildWrappedWidget(IngredientCard(
          name: mockProductName,
          initiallyChecked: false,
          evenRow: true,
          onChecked: (isChecked) {},
        )),
      );

      final cardFinder = find.byType(IngredientCard);
      final titleFinder = find.text(mockProductName);

      expect(cardFinder, findsOneWidget);
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('can be checked when tapped in FitHerb list', (WidgetTester tester) async {
      var isChecked = false;
      await tester.pumpWidget(
        _buildWrappedWidget(IngredientCard(
          name: mockProductName,
          initiallyChecked: isChecked,
          evenRow: true,
          onChecked: (newValue) {
            isChecked = newValue!;
          },
        )),
      );

      final cardFinder = find.byType(IngredientCard);
      await tester.tap(cardFinder);
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox);

      expect(checkboxFinder, findsOneWidget);
      expect(isChecked, isTrue);
    });
  });

  group('Golden Tests - ProductCard', () {
    testGoldens('can support light theme in FitHerb', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario(
          'Light - Unchecked',
          IngredientCard(
            name: mockProductName,
            initiallyChecked: false,
            evenRow: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Light - Checked',
          IngredientCard(
            name: mockProductName,
            initiallyChecked: true,
            evenRow: true,
            onChecked: (newValue) {},
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: ThemeData.light(),
        ),
      );

      await screenMatchesGolden(tester, 'light_product_card');
    });

    testGoldens('can support dark theme in FitHerb', (tester) async {
      final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 1)
        ..addScenario(
          'Dark - Unchecked',
          IngredientCard(
            name: mockProductName,
            initiallyChecked: false,
            evenRow: true,
            onChecked: (newValue) {},
          ),
        )
        ..addScenario(
          'Dark - Checked',
          IngredientCard(
            name: mockProductName,
            initiallyChecked: true,
            evenRow: true,
            onChecked: (newValue) {},
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark(),
        ),
      );

      await screenMatchesGolden(tester, 'dark_product_card');
    });
  });
}
