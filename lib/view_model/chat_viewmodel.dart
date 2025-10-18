import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewModel {
  final _db = FirebaseFirestore.instance;

  String getChatId(String user1, String user2) {
    return user1.hashCode <= user2.hashCode ? '${user1}_$user2' : '${user2}_$user1';
  }

  Future<void> sendMessage(String chatId, String from, String to, String content) async {
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'from': from,
      'to': to,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'reaction': null,
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await _db.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();
  }

  Future<void> reactToMessage(String chatId, String messageId, String? emoji) async {
    await _db.collection('chats').doc(chatId).collection('messages').doc(messageId).update({'reaction': emoji});
  }
}
