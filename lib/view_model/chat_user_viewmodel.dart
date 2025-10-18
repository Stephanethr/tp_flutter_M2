import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chat_user.dart';

class ChatUserViewModel {
  final _db = FirebaseFirestore.instance;

  Stream<List<ChatUser>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ChatUser.fromMap(doc.data(), doc.id)).toList());
  }
}
