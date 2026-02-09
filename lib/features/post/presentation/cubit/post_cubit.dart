import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/core/services/cloudinary_service.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';

part 'post_state.dart';

@injectable
class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final CloudinaryService cloudinaryService;

  PostCubit({required this.postRepo, required this.cloudinaryService})
    : super(PostInitial());

  // create new post
  Future<void> createPost(Post post, {File? image}) async {
    try {
      emit(PostLoading());
      emit(PostUpLoading());

      String imageUrl = post.imageUrl;
      // Upload to Cloudinary if image is provided
      if (image != null) {
        final uploadedUrl = await cloudinaryService.uploadImage(image);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          throw Exception("Failed to upload image to Cloudinary");
        }
      }

      // Create updated post with image URL
      final newPost = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        text: post.text,
        imageUrl: imageUrl,
        timeStamp: post.timeStamp,
        likes: [],
        comments: [],
      );

      // Save post to repository
      await postRepo.createPost(newPost);

      // re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to create post: ${e.toString()}'));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fectchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
    }
  }

  // refresh posts silently without showing loading indicator
  Future<void> refreshPosts() async {
    try {
      final posts = await postRepo.fectchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      // Silently fail - don't show error if we already have posts
      if (state is! PostLoaded) {
        emit(PostError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
      }
    }
  }

  // fetch all posts by user id
  Future<void> fetchAllPostsByUserId({required String userId}) async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fectchAllPostsByUserId(userId);
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
    }
  }

  // delete post
  Future<void> deletePost({required String postId}) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to delete post: ${e.toString()}'));
    }
  }

  // toggle like
  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await postRepo.toggleLikePost(postId: postId, userId: userId);
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to Like post: ${e.toString()}'));
    }
  }

  // add a comment
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId: postId, comment: comment);
      fetchAllPosts();
    } catch (e) {
      emit(
        PostError(
          errorMessage: 'Failed to add comment to post: ${e.toString()}',
        ),
      );
    }
  }

  // delete a comment
  Future<void> deleteComment(String postId, Comment comment) async {
    try {
      await postRepo.deleteComment(postId: postId, comment: comment);
    } catch (e) {
      emit(
        PostError(
          errorMessage: 'Failed to delete comment from post: ${e.toString()}',
        ),
      );
    }
  }
}
