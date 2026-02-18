class AppUser {
  final String uid;
  final String username;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final bool? isVerified;

  // Counters instead of Lists for scalability
  final int? followersCount;
  final int? followingCount;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  factory AppUser.fromMap(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      profileImage: json['profileImage'],
      isVerified: json['isVerified'],
      followersCount: json['followersCount'],
      followingCount: json['followingCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'isVerified': isVerified,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}
