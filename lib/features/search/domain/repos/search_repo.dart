import 'package:social_media_app_using_firebase/features/profile/domain/models/profile_user.dart';

abstract class SearchRepo {
  Future<List<ProfileUser>> searchUsers(String query);
}
