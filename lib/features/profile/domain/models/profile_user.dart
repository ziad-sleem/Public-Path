import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';

class ProfileUser extends AppUser {
  final String? bio;
  final String? profileImageUrl;

  ProfileUser({
    this.bio,
    this.profileImageUrl,
    required super.uid,
    required super.username,
    required super.email,
    super.profileImage,
    super.followersCount,
    super.followingCount,
  });

  factory ProfileUser.fromMap(Map<String, dynamic> json) {
    return ProfileUser(
      bio: json['bio'],
      profileImageUrl: json['profileImageUrl'],
      uid: json['uid'],
      username: json['username'],
      email: json['email'],
      profileImage: json['profileImage'],
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }

  @override
  ProfileUser copyWith({
    String? username,
    String? bio,
    String? profileImage,
    int? followersCount,
    int? followingCount,
    bool? isVerified,
    String? profileImageUrl,
  }) {
    return ProfileUser(
      uid: uid,
      username: username ?? this.username,
      email: email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'uid': uid,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}
