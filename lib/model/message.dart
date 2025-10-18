class Message {
  final String id;
  final String from;
  final String to;
  final String content;
  final DateTime? timestamp;
  final String? reaction;

  Message({
    required this.id,
    required this.from,
    required this.to,
    required this.content,
    required this.timestamp,
    this.reaction,
  });

  factory Message.fromMap(Map<String, dynamic> data, String id) {
    return Message(
      id: id,
      from: data['from'],
      to: data['to'],
      content: data['content'],
      timestamp: (data['timestamp'] != null)
          ? DateTime.fromMillisecondsSinceEpoch(
          data['timestamp'].millisecondsSinceEpoch)
          : null,
      reaction: data['reaction'],
    );
  }
}
