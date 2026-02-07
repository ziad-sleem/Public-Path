import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fectchAllPosts();
  Future<List<Post>> fectchAllPostsByUserId(String userId);
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
  Future<void> toggleLikePost({required String postId, required String userId});
  Future<void> addComment({required String postId, required Comment comment});
  Future<void> deleteComment({
    required String postId,
    required Comment comment,
  });
}
