import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreenState {
  final int selectedIndex;
  const MainScreenState({this.selectedIndex = 0});
}

class MainScreenStateProvider extends StateNotifier<MainScreenState> {
  MainScreenStateProvider() : super(const MainScreenState());

  void updateSelectedIndex(int index) {
    state = MainScreenState(selectedIndex: index);
  }
}

final bottomNavigationProvider =
    StateNotifierProvider<MainScreenStateProvider, MainScreenState>((ref) {
  return MainScreenStateProvider();
});
