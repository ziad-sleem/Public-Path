import 'package:social_media_app_using_firebase/features/create_post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';

abstract class HomeRepo {
  Stream<List<Post>> fectchAllPosts();
  Stream<List<Post>> fectchAllPostsByUserId(String userId);
  Future<void> deletePost(String postId);
  Future<void> toggleLikePost({required String postId, required String userId});
  Future<void> addComment({required String postId, required Comment comment});
  Future<void> deleteComment({
    required String postId,
    required Comment comment,
  });
}