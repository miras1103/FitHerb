import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';
import 'user_dao.dart';

class MessageDao {
  MessageDao(this.userDao);
  final UserDao userDao;

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('messages');

  void sendMessage(String text) {
    final message = Message(
      date: DateTime.now(),
      email: userDao.email()!,
      text: text,
    );
    collection.add(message.toJson());
  }

  Stream<List<Message>> getMessageStream() {
    return collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList();
    });
  }
}
