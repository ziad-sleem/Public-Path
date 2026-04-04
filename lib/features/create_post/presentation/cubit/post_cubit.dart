import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/config/cloudinary/cloudinary_service.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/repo/post_repo.dart';
import 'package:social_media_app_using_firebase/features/home/domain/repos/home_repo.dart';

part 'post_state.dart';

@injectable
class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;
  final HomeRepo homeRepo;
  final CloudinaryService cloudinaryService;

  bool loaded = false;

  PostCubit({
    required this.postRepo,
    required this.cloudinaryService,
    required this.homeRepo,
  }) : super(PostInitial());

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
        text: post.text,
        imageUrl: imageUrl,
        timeStamp: post.timeStamp,
        likes: [],
        comments: [],
      );

      // Save post to repository
      await postRepo.createPost(newPost);

      // re-fetch all posts
      await fetchAllPosts();

    } catch (e) {
      emit(PostError(errorMessage: 'Failed to create post: ${e.toString()}'));
    }
  }

  // fetch all posts
  Future<void> fetchAllPosts() async {
    try {
      emit(PostLoading());
      final posts = homeRepo.fectchAllPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(errorMessage: 'Failed to fetch post: ${e.toString()}'));
    }
  }
}
