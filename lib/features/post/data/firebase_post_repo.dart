import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/repos/profile_repo.dart';

@LazySingleton(as: PostRepo)
class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore;

  // Use interfaces instead of concrete classes for better decoupling
  final ProfileRepo profileRepo;
  final AuthRepo authRepo;

  FirebasePostRepo({
    required this.firebaseFirestore,
    required this.profileRepo,
    required this.authRepo,
  });

  // Helper for collection reference
  CollectionReference get postCollection =>
      firebaseFirestore.collection('posts');

  @override
  Future<List<Post>> fectchAllPosts() async {
    try {
      final postsSnapshot = await postCollection
          .orderBy('timeStamp', descending: true)
          .get();

      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      final currentUser = await authRepo.getCurrentUser();

      if (currentUser == null) {
        return [];
      }

      final followings = await profileRepo.fetchFollowings(
        uid: currentUser.uid,
      );

      final List<Post> followingPosts = allPosts.where((post) {
        return post.userId == currentUser.uid ||
            (followings?.following.contains(post.userId) ?? false);
      }).toList();

      return followingPosts;
    } catch (e) {
      throw Exception("Error fetching posts: ${e.toString()}");
    }
  }

  @override
  Future<List<Post>> fectchAllPostsByUserId(String userId) async {
    try {
      final postSnapshot = await postCollection
          .where('userId', isEqualTo: userId)
          .get();

      List<Post> allPostsByUserId = postSnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return allPostsByUserId;
    } catch (e) {
      throw Exception("Error fetching posts: ${e.toString()}");
    }
  }

  @override
  Future<void> createPost(Post post) async {
    try {
      await postCollection.doc(post.id).set(post.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await postCollection.doc(postId).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> toggleLikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);
        final hasLiked = post.likes.contains(userId);

        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await postCollection.doc(postId).update(post.toMap());
      } else {
        throw Exception("Post Not Found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> addComment({
    required String postId,
    required Comment comment,
  }) async {
    try {
      await postCollection.doc(postId).update({
        'comments': FieldValue.arrayUnion([comment.toJson()]),
      });
    } catch (e) {
      throw Exception("Error adding comment: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required Comment comment,
  }) async {
    try {
      await postCollection.doc(postId).update({
        'comments': FieldValue.arrayRemove([comment.toJson()]),
      });
    } catch (e) {
      throw Exception("Error deleting comment: ${e.toString()}");
    }
  }
}
