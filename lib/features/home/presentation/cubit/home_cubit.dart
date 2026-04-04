import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/home/domain/repos/home_repo.dart';
import 'package:social_media_app_using_firebase/features/home/presentation/cubit/home_event.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  bool loaded = false;
  StreamSubscription? _postSubscription;

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }

  void doEvent(HomeEvent event) {
    switch (event) {
      case FetchAllPostEvent():
        _fetchAllPosts();
      case RefreshPostEvent():
        _refreshPosts();
      case FetchAllPostByUserIdEvent():
        _fetchAllPostsByUserId(userId: event.userId);
      case DeletePostEvent():
        _deletePost(postId: event.postId);
      case ToggleLikePostEvent():
        _toggleLikePost(postId: event.postId, userId: event.userId);
      case AddCommentEvent():
        _addComment(postId:  event.postId,comment:  event.comment);
      case DeleteCommentEvent():
        _deleteComment(postId:  event.postId,comment:  event.comment);
    }
  }

  // fetch all posts
  Future<void> _fetchAllPosts() async {
    try {
      emit(HomeLoading());
      _postSubscription?.cancel();
      _postSubscription = homeRepo.fectchAllPosts().listen(
        (posts) {
          emit(HomeLoaded(posts: posts));
        },
        onError: (e) {
          emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
        },
      );
    } catch (e) {
      emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
    }
  }

  // refresh posts silently without showing loading indicator
  Future<void> _refreshPosts() async {
    try {
      _postSubscription?.cancel();
      _postSubscription = homeRepo.fectchAllPosts().listen(
        (posts) {
          emit(HomeLoaded(posts: posts));
        },
        onError: (e) {
          if (state is! HomeLoaded) {
            emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
          }
        },
      );
    } catch (e) {
      if (state is! HomeLoaded) {
        emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
      }
    }
  }

  // fetch all posts by user id
  Future<void> _fetchAllPostsByUserId({required String userId}) async {
    try {
      emit(HomeLoading());
      _postSubscription?.cancel();
      _postSubscription = homeRepo.fectchAllPostsByUserId(userId).listen(
        (posts) {
          emit(HomeLoaded(posts: posts));
        },
        onError: (e) {
          emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
        },
      );
    } catch (e) {
      emit(HomeError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
    }
  }

  // delete post
  Future<void> _deletePost({required String postId}) async {
    try {
      await homeRepo.deletePost(postId);
      _refreshPosts();
    } catch (e) {
      emit(HomeError(errorMessage: 'Failed to delete post: ${e.toString()}'));
    }
  }

  // toggle like
  Future<void> _toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await homeRepo.toggleLikePost(postId: postId, userId: userId);
    } catch (e) {
      emit(HomeError(errorMessage: 'Failed to Like post: ${e.toString()}'));
    }
  }

  // add a comment
  Future<void> _addComment({required String postId,required Comment comment}) async {
    try {
      await homeRepo.addComment(postId: postId, comment: comment);
      _fetchAllPosts();
    } catch (e) {
      emit(
        HomeError(
          errorMessage: 'Failed to add comment to post: ${e.toString()}',
        ),
      );
    }
  }

  // delete a comment
  Future<void> _deleteComment({
   required String postId,required Comment comment}) async {
    try {
      await homeRepo.deleteComment(postId: postId, comment: comment);
      _fetchAllPosts();
    } catch (e) {
      emit(
        HomeError(
          errorMessage: 'Failed to delete comment from post: ${e.toString()}',
        ),
      );
    }
  }
}
