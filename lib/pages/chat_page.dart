import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String peerAvatarUrl; // <- avatarUrl du peer
  const ChatPage({
    super.key,
    required this.peerId,
    required this.peerName,
    required this.peerAvatarUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final messageController = TextEditingController();
  String currentUserAvatarUrl = '';

  @override
  void initState() {
    super.initState();
    // Récupérer avatarUrl de l'utilisateur actuel depuis Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((doc) {
      setState(() {
        currentUserAvatarUrl = doc.data()?['avatarUrl'] ?? '';
      });
    });
  }

  String getChatId() {
    return currentUser.uid.hashCode <= widget.peerId.hashCode
        ? '${currentUser.uid}_${widget.peerId}'
        : '${widget.peerId}_${currentUser.uid}';
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    final chatId = getChatId();
    final msg = messageController.text.trim();
    messageController.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'from': currentUser.uid,
      'to': widget.peerId,
      'content': msg,
      'timestamp': FieldValue.serverTimestamp(),
      'reaction': null,
    });
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  Future<void> reactToMessage(
      String chatId, String messageId, String? emoji, String? currentReaction) async {
    final newReaction = (emoji == currentReaction) ? null : emoji;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'reaction': newReaction});
  }

  void showReactionMenu(
      BuildContext context, String chatId, String messageId, bool isMe, String? currentReaction) {
    final emojis = ['❤️', '😂', '👍', '😮', '😢', '👎'];
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.only(bottom: 80),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final e in emojis)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        reactToMessage(chatId, messageId, e, currentReaction);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  if (isMe)
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Supprimer le message ?'),
                            content: const Text('Cette action est irréversible.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(c, false),
                                child: const Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(c, true),
                                child: const Text('Supprimer'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await deleteMessage(chatId, messageId);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId();

    return Scaffold(
      appBar: AppBar(title: Text('Chat avec ${widget.peerName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final doc = docs[i];
                    final data = doc.data() as Map<String, dynamic>;
                    final isMe = data['from'] == currentUser.uid;
                    final date = data['timestamp'] != null
                        ? DateFormat('HH:mm').format((data['timestamp'] as Timestamp).toDate())
                        : '';
                    final reaction = data['reaction'];

                    final avatarUrl = isMe ? currentUserAvatarUrl : widget.peerAvatarUrl;

                    return GestureDetector(
                      onLongPress: () =>
                          showReactionMenu(context, chatId, doc.id, isMe, reaction),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // <-- alignement vertical des avatars
                        mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isMe)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 2), // <-- léger top padding
                              child: CircleAvatar(
                                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                                child: avatarUrl.isEmpty
                                    ? Text(
                                  widget.peerName[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                                    : null,
                                backgroundColor: Colors.deepPurple,
                              ),
                            ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isMe ? Colors.deepPurple[100] : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(data['content']),
                                    ),
                                    if (reaction != null)
                                      Positioned(
                                        bottom: -12,
                                        left: isMe ? 0 : null,
                                        right: isMe ? null : 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(color: Colors.black12, blurRadius: 2)
                                            ],
                                          ),
                                          child: Text(
                                            reaction,
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Text(date,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (isMe)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 2), // <-- léger top padding
                              child: CircleAvatar(
                                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                                child: avatarUrl.isEmpty
                                    ? Text(
                                  currentUser.displayName![0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                )
                                    : null,
                                backgroundColor: Colors.deepPurple,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Écrire un message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
