import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/video_picker_service.dart';
import 'package:social_media_app_using_firebase/features/vistas/domain/repos/vedio_repo.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_event.dart';
import 'package:social_media_app_using_firebase/features/vistas/presentation/cubit/video_state.dart';

@injectable
class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoPickerService _pickerService;
  final VideoRepository _repository;

  VideoBloc(this._pickerService, this._repository)
    : super(const VideoInitial()) {
    on<VideoPickedEvent>(_onVideoPicked);
    on<FetchAllVideosEvent>(_onFetchAllVideos);
    on<FetchAllVideosByUserIdEvent>(_onFetchVideosByUserId);
    on<LikeVideoEvent>(_onLikeVideo);
    on<DislikeVideoEvent>(_onDislikeVideo);
  }

  Future<void> _onVideoPicked(
    VideoPickedEvent event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoPicking());
    try {
      final file = event.fromGallery
          ? await _pickerService.pickVideoFromGallery()
          : await _pickerService.pickVideoFromCamera();

      if (file == null) {
        emit(const VideoInitial());
        return;
      }

      emit(const VideoUploading(0.0));
      final videoEntity = await _repository.uploadVideo(file);
      emit(VideoReady(videoEntity.videoUrl));
    } catch (e) {
      emit(VideoError("Operation failed: ${e.toString()}"));
    }
  }

  Future<void> _onFetchAllVideos(
    FetchAllVideosEvent event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoLoading());
    await emit.forEach(
      _repository.fetchAllVideos(),
      onData: (videos) => VideosLoaded(videos),
      onError: (e, stack) => VideoError("Failed to fetch videos: ${e.toString()}"),
    );
  }

  Future<void> _onFetchVideosByUserId(
    FetchAllVideosByUserIdEvent event,
    Emitter<VideoState> emit,
  ) async {
    emit(const VideoLoading());
    await emit.forEach(
      _repository.fetchAllVideosByUserId(event.userId),
      onData: (videos) => VideosLoaded(videos),
      onError: (e, stack) => VideoError("Failed to fetch user videos: ${e.toString()}"),
    );
  }

  Future<void> _onLikeVideo(
    LikeVideoEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      await _repository.likeVideo(event.videoId, event.userId);
    } catch (e) {
      emit(VideoError("Failed to like video: ${e.toString()}"));
    }
  }

  Future<void> _onDislikeVideo(
    DislikeVideoEvent event,
    Emitter<VideoState> emit,
  ) async {
    try {
      await _repository.dislikeVideo(event.videoId, event.userId);
    } catch (e) {
      emit(VideoError("Failed to dislike video: ${e.toString()}"));
    }
  }
}
