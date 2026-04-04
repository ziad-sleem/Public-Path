import 'dart:developer' as dev;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:social_media_app_using_firebase/features/auth/domain/repos/auth_repo.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/comment.dart';
import 'package:social_media_app_using_firebase/features/create_post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/home/domain/repos/home_repo.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/repos/profile_repo.dart';

@Injectable(as: HomeRepo)
class FirebaseHomeRepo implements HomeRepo {
  final FirebaseFirestore firebaseFirestore;
  final ProfileRepo profileRepo;
  final AuthRepo authRepo;

  FirebaseHomeRepo({
    required this.firebaseFirestore,
    required this.profileRepo,
    required this.authRepo,
  });

  CollectionReference get postCollection =>
      firebaseFirestore.collection('posts');

  @override
  Stream<List<Post>> fectchAllPosts() async* {
    try {
      final currentUser = await authRepo.getCurrentUser();

     

      final followings = await profileRepo.fetchFollowings(
        uid: currentUser!.uid,
      );

      final followingList = followings?.following ?? [];
      dev.log("FirebaseHomeRepo: User ${currentUser.uid} follows ${followingList.length} users: $followingList");

      yield* postCollection
          .orderBy('timeStamp', descending: true)
          .snapshots()
          .map((snapshot) {
        final allPosts = snapshot.docs
            .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        final filteredPosts = allPosts.where((post) {
          final bool isMine = post.userId == currentUser.uid;
          final bool isFollowing = followingList.contains(post.userId);
          return isMine || isFollowing;
        }).toList();

        dev.log(
            "FirebaseHomeRepo: All posts: ${allPosts.length}, Filtered posts: ${filteredPosts.length}");

        return filteredPosts;
      });
    } catch (e) {
      dev.log("FirebaseHomeRepo Error: ${e.toString()}");
      throw Exception("Error fetching posts: ${e.toString()}");
    }
  }

  @override
  Stream<List<Post>> fectchAllPostsByUserId(String userId) {
    try {
      return postCollection
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        List<Post> allPostsByUserId = snapshot.docs
            .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        return allPostsByUserId;
      });
    } catch (e) {
      throw Exception("Error fetching posts: ${e.toString()}");
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
