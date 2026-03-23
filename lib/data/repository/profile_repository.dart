import '../database/models/UserModel.dart';
import '../sources/profile_source.dart';

class ProfileRepository {
  ProfileRepository(this.source);

  final ProfileSource source;

  Future<UserModel?> getUserById(int userId) {
    return source.getUserById(userId);
  }

  Future<UserModel?> getPrimaryUser() {
    return source.getPrimaryUser();
  }

  Future<bool> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String email,
  }) {
    return source.updateProfile(
      userId: userId,
      fullName: fullName,
      phone: phone,
      email: email,
    );
  }

  Future<bool> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) {
    return source.updatePassword(
      userId: userId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<bool> deleteAccount({required int userId, required String password}) {
    return source.deleteAccount(userId: userId, password: password);
  }
}
