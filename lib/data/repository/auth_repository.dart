import '../sources/auth_source.dart';

class AuthRepository {
  final AuthSource source;

  AuthRepository(this.source);

  Future<bool> login(String email, String password) {
    return source.login(email, password);
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
  }) {
    return source.register(
      fullName: fullName,
      email: email,
      phone: phone,
      birthDate: birthDate,
      password: password,
    );
  }

  Future<bool> checkEmailExists(String email) {
    return source.checkEmailExists(email);
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) {
    return source.resetPassword(email: email, newPassword: newPassword);
  }
}