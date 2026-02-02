class AppUser {
  final String uid;
  final String username;
  final String email;
  final String? bio;
  final String? profileImage;
  final DateTime createdAt;
  final String? phoneNumber;
  final bool? isVerified;
  
  // Counters instead of Lists for scalability
  final int? followersCount;
  final int? followingCount;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    this.bio,
    this.profileImage,
    required this.createdAt,
    this.phoneNumber,
    this.isVerified = false,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  // Use copyWith to update specific fields easily
  AppUser copyWith({
    String? username,
    String? bio,
    String? profileImage,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
  }) {
    return AppUser(
      uid: this.uid,
      username: username ?? this.username,
      email: this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      createdAt: this.createdAt,
      phoneNumber: this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'phoneNumber': phoneNumber,
      'isVerified': isVerified,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'],
      profileImage: map['profileImage'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      phoneNumber: map['phoneNumber'],
      isVerified: map['isVerified'] ?? false,
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
    );
  }
}