
// import 'package:social_media_app_using_firebase/features/auth/domain/entities/app_user.dart';

// class ProfileUser extends AppUser {
//   final String bio;
//   final String profileImageUrl;

//   ProfileUser({
//     required super.userId,
//     required super.email,
//     required super.name,
//     required this.bio,
//     required this.profileImageUrl, required super.uid, required super.username, required super.createdAt,
//   });

//   // method to update profile user
//   ProfileUser copyWith({String? newBio, String? newProfileImageUrl}) {
//     return ProfileUser(
//       userId: userId,
//       email: email,
//       name: name,
//       bio: newBio ?? bio,
//       profileImageUrl: newProfileImageUrl ?? profileImageUrl, uid: '', username: '', createdAt: null,
//     );
//   }

//   // convert profile user => json
//   Map<String, dynamic> toJson() {
//     return {
//       'userId': userId,
//       'email': email,
//       'name': name,
//       'bio': bio,
//       'profileImageUrl': profileImageUrl,
//     };
//   }

//   // convert json => app user
//   factory ProfileUser.fromJson(Map<String, dynamic> json) {
//     return ProfileUser(
//       userId: json['userId'],
//       email: json['email'],
//       name: json['name'],
//       bio: json['bio']  ?? '',
//       profileImageUrl: json['profileImageUrl'] ?? '' ,
//     );
//   }
// }
