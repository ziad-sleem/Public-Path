import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;
  final List<String> likes; // store uids
  final List<Comment> comments;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timeStamp,
    required this.likes,
    required this.comments,
  });

  factory Post.fromMap(Map<String, dynamic> json) {
    // prepare comments
    final List<Comment> comments =
        (json['comments'] as List<dynamic>?)
            ?.map((commentJson) => Comment.fromJson(commentJson))
            .toList() ??
        [];

    return Post(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timeStamp: DateTime.fromMillisecondsSinceEpoch(json['timeStamp'] ?? 0),
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
