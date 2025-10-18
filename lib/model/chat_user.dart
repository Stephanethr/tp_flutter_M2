class ChatUser {
  final String uid;
  final String displayName;
  final String? avatarUrl;
  final String? bio;

  ChatUser({
    required this.uid,
    required this.displayName,
    this.avatarUrl,
    this.bio,
  });

  factory ChatUser.fromMap(Map<String, dynamic> data, String uid) {
    return ChatUser(
      uid: uid,
      displayName: data['displayName'] ?? '',
      avatarUrl: data['avatarUrl'],
      bio: data['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'bio': bio,
    };
  }
}
