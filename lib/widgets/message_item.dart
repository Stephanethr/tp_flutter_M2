import 'package:flutter/material.dart';
import '../model/message.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final bool isMe;
  final VoidCallback onLongPress;

  const MessageItem({
    super.key,
    required this.message,
    required this.isMe,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isMe ? Colors.deepPurple[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(message.content),
            ),
            if (message.reaction != null)
              Text(message.reaction!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
