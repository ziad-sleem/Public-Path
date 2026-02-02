import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app_using_firebase/features/post/domain/entities/post.dart';
import 'package:social_media_app_using_firebase/features/post/domain/repo/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference postCollection = FirebaseFirestore.instance
      .collection('posts');

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
      // return the list
      return allPosts;
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
}
