class Chat {
  final String id;
  final List<String> members;

  Chat({required this.id, required this.members});

  factory Chat.fromIds(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return Chat(id: '${sorted[0]}_${sorted[1]}', members: sorted);
  }
}
