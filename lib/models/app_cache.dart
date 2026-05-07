import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const klogin = 'yummy_login';
  static const kPreviousSearches = 'previous_searches';
  static const kSelectedIndex = 'selected_index';

  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(klogin, false);
  }

  Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(klogin, true);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(klogin) ?? false;
  }

  Future<List<String>> getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(kPreviousSearches) ?? [];
  }

  Future<void> addSearch(String search) async {
    final prefs = await SharedPreferences.getInstance();
    final searches = await getPreviousSearches();
    if (!searches.contains(search)) {
      searches.insert(0, search);
      if (searches.length > 5) {
        searches.removeLast();
      }
      await prefs.setStringList(kPreviousSearches, searches);
    }
  }

  Future<void> removeSearch(String search) async {
    final prefs = await SharedPreferences.getInstance();
    final searches = await getPreviousSearches();
    searches.remove(search);
    await prefs.setStringList(kPreviousSearches, searches);
  }

  Future<void> clearSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPreviousSearches);
  }

  Future<int> getSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(kSelectedIndex) ?? 0;
  }

  Future<void> setSelectedIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kSelectedIndex, index);
  }
}
