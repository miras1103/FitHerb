import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories/db_repository.dart';
import 'data/models/current_recipe_data.dart';
import 'api/spoonacular_service.dart';
import 'models/user_dao.dart';
import 'models/message_dao.dart';
import 'models/message.dart';
import 'models/bookmark_manager.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final repositoryProvider =
    NotifierProvider<DBRepository, CurrentRecipeData>(() {
  throw UnimplementedError();
});

final serviceProvider = Provider<SpoonacularService>((ref) {
  throw UnimplementedError();
});

final userDaoProvider = ChangeNotifierProvider<UserDao>((ref) {
  return UserDao();
});

final bookmarkProvider = ChangeNotifierProvider<BookmarkManager>((ref) {
  final user = ref.watch(userDaoProvider);
  final uid = user.userId();
  return BookmarkManager(uid);
});

final messageDaoProvider = Provider<MessageDao>((ref) {
  return MessageDao(ref.watch(userDaoProvider));
});

final messageListProvider = StreamProvider<List<Message>>((ref) {
  final messageDao = ref.watch(messageDaoProvider);
  return messageDao.getMessageStream();
});
