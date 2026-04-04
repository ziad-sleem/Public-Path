import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/config/DI/injection.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/cloudinary_service.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/auth_cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/create_video/domain/entities/video_entity.dart';
import 'package:social_media_app_using_firebase/features/vistas/domain/repos/vedio_repo.dart';

@LazySingleton(as: VideoRepository)
class VideoRepositoryImpl implements VideoRepository {
  final FirebaseFirestore firebaseFirestore;
  final CloudinaryService cloudinaryService;

  VideoRepositoryImpl({
    required this.firebaseFirestore,
    required this.cloudinaryService,
  });

  // Helper for collection reference
  CollectionReference get videoCollection =>
      firebaseFirestore.collection('videos');

  @override
  Stream<List<VideoEntity>> fetchAllVideos() {
    try {
      return videoCollection
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => VideoEntity.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      throw Exception("Error fetching Videos: ${e.toString()}");
    }
  }

  @override
  Stream<List<VideoEntity>> fetchAllVideosByUserId(String userId) {
    try {
      return videoCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => VideoEntity.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      throw Exception("Error fetching Videos: ${e.toString()}");
    }
  }

  @override
  Future<VideoEntity> uploadVideo(File file) async {
    try {
      final videoUrl = await cloudinaryService.uploadVideo(file);

      if (videoUrl == null) {
        throw Exception("Cloudinary upload failed");
      }

      String finalUrl = videoUrl.replaceAll(RegExp(r'\.[^.]+$'), '.m3u8');

      final newVideo = VideoEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: getIt<AuthCubit>().currentUser!.uid, 
        caption: "New Video",
        description: "New Video",
        videoUrl: finalUrl,
        userName: "",
        userImage: "",
        thumbnailUrl: "",
        videoCover: "", 
        timeStamp: DateTime.now(),
        likes: [],
        disLikes: [],
        comments: [],
      );

      // Save metadata to Firestore
      await videoCollection.doc(newVideo.id).set(newVideo.toMap());

      return newVideo;
    } catch (e) {
      throw Exception("Error uploading Video: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteVideo(String videoId) async {
    try {
      await videoCollection.doc(videoId).delete();
    } catch (e) {
      throw Exception("Error deleting Video: ${e.toString()}");
    }
  }

  @override
  Future<void> likeVideo(String videoId, String userId) async {
    try {
      final docRef = videoCollection.doc(videoId);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final likes = List<String>.from(data['likes'] ?? []);

      if (likes.contains(userId)) {
        await docRef.update({
          'likes': FieldValue.arrayRemove([userId])
        });
      } else {
        await docRef.update({
          'likes': FieldValue.arrayUnion([userId]),
          'disLikes': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      throw Exception("Error liking Video: ${e.toString()}");
    }
  }

  @override
  Future<void> dislikeVideo(String videoId, String userId) async {
    try {
      final docRef = videoCollection.doc(videoId);
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data() as Map<String, dynamic>;
      final likes = List<String>.from(data['likes'] ?? []);
      final dislikes = List<String>.from(data['disLikes'] ?? []);

      if (dislikes.contains(userId)) {
        await docRef.update({
          'disLikes': FieldValue.arrayRemove([userId])
        });
      } else {
        await docRef.update({
          'disLikes': FieldValue.arrayUnion([userId]),
          'likes': FieldValue.arrayRemove([userId])
        });
      }
    } catch (e) {
      throw Exception("Error disliking Video: ${e.toString()}");
    }
  }
}
