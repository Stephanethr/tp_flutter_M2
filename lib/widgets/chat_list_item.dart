import 'package:flutter/material.dart';
import '../model/chat_user.dart';

class ChatListItem extends StatelessWidget {
  final ChatUser user;
  final VoidCallback onTap;

  const ChatListItem({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null ? const Icon(Icons.person) : null,
      ),
      title: Text(user.displayName),
      subtitle: Text(user.bio ?? ''),
      onTap: onTap,
    );
  }
}
