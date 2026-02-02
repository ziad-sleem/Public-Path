// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:social_media_app_using_firebase/features/profile/domain/entities/repos/profile_repo.dart';

// class FirebaseProfileRepo implements ProfileRepo {

//   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


//   @override
//   Future<void> updateUser({
//     required String uid,
//     String? username,
//     String? bio,
//     String? profileImage,
//     String? coverImage,
//   }) async {
//     final Map<String, dynamic> data = {};

//     if (username != null) data['username'] = username;
//     if (bio != null) data['bio'] = bio;
//     if (profileImage != null) data['profileImage'] = profileImage;
//     if (coverImage != null) data['coverImage'] = coverImage;

//     await firebaseFirestore.collection("users").doc(uid).update(data);
//   }
// }
