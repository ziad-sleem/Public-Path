class Comment {
  final String id;
  final String text;
  final String postId;
  final String userId;
  final String userName;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.text,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}
