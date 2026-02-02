

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'userName': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      text: map['text'] as String,
      imageUrl: map['imageUrl'] as String,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(map['timeStamp'] as int),
    );
  }

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timeStamp: timeStamp,
    );
  }
}
