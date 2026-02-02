
abstract class ProfileRepo {
  Future<void> updateUser({
    required String uid,
    String? username,
    String? bio,
    String? profileImage,
    String? coverImage,
  });
}
