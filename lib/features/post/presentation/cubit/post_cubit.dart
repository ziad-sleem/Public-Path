import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';
import 'package:social_media_app_using_firebase/features/post/data/firebase_post_repo.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo = FirebasePostRepo();

  PostCubit() : super(PostInitial());

  // create new post
  Future<void> createPost(Post post, {File? image}) async {
    try {
      emit(PostLoading());
      emit(PostUpLoading());

      // Convert image to base64 if provided
      String imageUrl = post.imageUrl;
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        imageUrl = base64String;
      }

      // Create updated post with image URL
      final newPost = Post(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        text: post.text,
        imageUrl: imageUrl,
        timeStamp: post.timeStamp,
      );

      // Save post to repository
      await postRepo.createPost(newPost);

      // re-fetch all posts
      fetchAllPosts();
    } catch (e) {
      emit(PostError(errorMessage: 'Faild to create post: ${e.toString()}'));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fectchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(errorMessage: 'Faild to fetch post: ${e.toString()}'));
    }
  }

  // fetch all posts by user id
  Future<void> fetchAllPostsByUserId({required String userId}) async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fectchAllPostsByUserId(userId);
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(errorMessage: 'Faild to fetch post: ${e.toString()}'));
    }
  }

  // delete post
  Future<void> deletePost({required String postId}) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      emit(PostError(errorMessage: 'Faild to fetch post: ${e.toString()}'));
    }
  }
}
