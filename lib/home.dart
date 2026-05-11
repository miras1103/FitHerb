import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'components/components.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'constants.dart';
import 'providers.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final YummyAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final AppCache _appCache = AppCache();

  static const List<NavigationDestination> appBarDestinations = [
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      label: 'Explore',
      selectedIcon: Icon(Icons.explore),
    ),
    NavigationDestination(
      icon: Icon(Icons.list_outlined),
      label: 'Orders',
      selectedIcon: Icon(Icons.list),
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_outlined),
      label: 'Chat',
      selectedIcon: Icon(Icons.chat),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Account',
      selectedIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userDao = ref.watch(userDaoProvider);
    
    // Получаем актуальные данные пользователя
    final String userEmail = userDao.email() ?? 'Guest@fitherb.com';
    
    // Сначала пробуем взять displayName, если его нет - часть email
    final String userName = userDao.displayName() ?? (userEmail.contains('@') 
        ? userEmail.split('@')[0] 
        : userEmail);
    
    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
      ),
      const MyOrdersPage(),
      userDao.isLoggedIn() ? const MessageList() : const Login(),
      AccountPage(
        onLogOut: (logout) async {
          await widget.auth.signOut();
          userDao.logout();
          if (context.mounted) {
            context.go('/login');
          }
        },
        name: userName,
        email: userEmail,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
          if (userDao.isLoggedIn())
            IconButton(
              onPressed: () {
                userDao.logout();
                context.go('/login');
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: IndexedStack(
        index: widget.tab >= pages.length ? 0 : widget.tab,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab >= appBarDestinations.length ? 0 : widget.tab,
        onDestinationSelected: (index) {
          _appCache.setSelectedIndex(index);
          context.go('/$index');
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
