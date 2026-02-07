import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';
import 'package:social_media_app_using_firebase/features/search/domain/repos/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ProfileUser>> searchUsers(String query) async {
    try {
      final snapshot = await _firestore
          .collection('usersProfile')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => ProfileUser.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error searching users: $e');
    }
  }
}
