class Followers {
  final String userId;
  final List<String> followers;

  Followers({required this.userId, required this.followers});

  factory Followers.fromMap(Map<String, dynamic> json) {
    return Followers(
      userId: json['userId'],
      followers: List<String>.from(json['followers']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'followers': followers,
    };
  }
}
