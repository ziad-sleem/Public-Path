class Followings {
  final String userId;
  final List<String> following;

  Followings({required this.userId, required this.following});

  factory Followings.fromMap(Map<String, dynamic> json) {
    return Followings(
      userId: json['userId'],
      following: List<String>.from(json['following']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'userId': userId, 'following': following};
  }
}
