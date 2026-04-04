import 'dart:io';

import 'package:social_media_app_using_firebase/features/create_video/domain/entities/video_entity.dart';

abstract class VideoRepository {
  Stream<List<VideoEntity>> fetchAllVideos();
  Stream<List<VideoEntity>> fetchAllVideosByUserId(String userId);
  Future<VideoEntity> uploadVideo(File videoFile);
  Future<void> deleteVideo(String videoId);
  Future<void> likeVideo(String videoId, String userId);
  Future<void> dislikeVideo(String videoId, String userId);
}
