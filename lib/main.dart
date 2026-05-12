import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'constants.dart';
import 'providers.dart';
import 'api/spoonacular_service.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'home.dart';
import 'data/repositories/db_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final sharedPrefs = await SharedPreferences.getInstance();
  final service = SpoonacularService();

  final container = ProviderContainer(
    overrides: [
      sharedPrefProvider.overrideWithValue(sharedPrefs),
      serviceProvider.overrideWithValue(service),
      repositoryProvider.overrideWith(() => DBRepository()),
    ],
  );

  try {
    await container.read(repositoryProvider.notifier).init();
  } catch (e) {
    debugPrint('Database initialization failed: $e');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const Yummy(),
    ),
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad
      };
}

class Yummy extends ConsumerStatefulWidget {
  const Yummy({super.key});

  @override
  ConsumerState<Yummy> createState() => _YummyState();
}

class _YummyState extends ConsumerState<Yummy> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.green;

  final CartManager _cartManager = CartManager();
  final OrderManager _orderManager = OrderManager();
  final AppCache _appCache = AppCache();
  final YummyAuth _auth = YummyAuth(); 

  late final _router = GoRouter(
    initialLocation: '/0',
    refreshListenable: ref.read(userDaoProvider),
    redirect: _appRedirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          onLogIn: (Credentials credentials) async {
            final error = await ref.read(userDaoProvider).login(
                  credentials.username,
                  credentials.password,
                );
            if (error != null) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
              }
            }
          },
          onSignUp: (Credentials credentials) async {
            final error = await ref.read(userDaoProvider).signup(
                  credentials.username,
                  credentials.password,
                );
            if (error != null) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error)),
                );
              }
            }
          },
        ),
      ),
      GoRoute(
          path: '/:tab',
          builder: (context, state) {
            final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
            return Home(
                auth: _auth,
                cartManager: _cartManager,
                ordersManager: _orderManager,
                changeTheme: changeThemeMode,
                changeColor: changeColor,
                colorSelected: colorSelected,
                tab: tab);
          },
          routes: [
            GoRoute(
                path: 'restaurant/:id',
                builder: (context, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  final restaurant = restaurants[id];
                  return RestaurantPage(
                    restaurant: restaurant,
                    cartManager: _cartManager,
                    ordersManager: _orderManager,
                  );
                }),
          ]),
    ],
  );

  Future<String?> _appRedirect(
      BuildContext context, GoRouterState state) async {
    final userDao = ref.read(userDaoProvider);
    final loggedIn = userDao.isLoggedIn();
    final isOnLoginPage = state.matchedLocation == '/login';

    if (!loggedIn) {
      return '/login';
    } else if (loggedIn && isOnLoginPage) {
      final index = await _appCache.getSelectedIndex();
      return '/$index';
    }

    return null;
  }

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FitHerb', // Визуальное название приложения
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
    );
  }
}
