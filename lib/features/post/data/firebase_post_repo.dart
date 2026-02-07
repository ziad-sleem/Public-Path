import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app_using_firebase/features/auth/data/firebase_auth_repo.dart';
import 'package:social_media_app_using_firebase/features/auth/peresnetation/cubits/cubit/auth_cubit.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/data/firebase_profile_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference postCollection = FirebaseFirestore.instance
      .collection('posts');

  final FirebaseProfileRepo firebaseProfileRepo = FirebaseProfileRepo();
  final FirebaseAuthRepo firebaseAuthRepo = FirebaseAuthRepo();

  @override
  Future<List<Post>> fectchAllPosts() async {
    try {
      // get all the posts ordered by the time
      final postsSnapshot = await postCollection
          .orderBy('timeStamp', descending: true)
          .get();
      // convert the list into list of post
      final List<Post> allPosts = postsSnapshot.docs
          .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // filter the posts to get only the posts of the users I follow
      final currentUser = await firebaseAuthRepo.getCurrentUser();

      if (currentUser == null) {
        return [];
      }

      final followings = await firebaseProfileRepo.fetchFollowings(
        uid: currentUser.uid,
      );

      final List<Post> followingPosts = allPosts.where((post) {
        return post.userId == currentUser.uid ||
            followings!.following.contains(post.userId);
      }).toList();

      // return the list
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
      // get the post document form firestore
      final postDoc = await postCollection.doc(postId).get();

      if (postDoc.exists) {
        final post = Post.fromMap(postDoc.data() as Map<String, dynamic>);

        // chech if user has already like this post
        final hasLiked = post.likes.contains(userId);

        // update the like list
        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        // update the post in firestore
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
