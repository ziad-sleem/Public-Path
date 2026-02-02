import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';

abstract class PostRepo {
  Future<List<Post>> fectchAllPosts();
  Future<List<Post>> fectchAllPostsByUserId(String userId);
  Future<void> createPost(Post post);
  Future<void> deletePost(String postId);
}
