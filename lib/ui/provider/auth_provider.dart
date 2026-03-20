import 'package:flutter/material.dart';

import '../../data/repository/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider(this.repository);

  bool isLoading = false;
  String? errorMessage;
  String? _resetEmail;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await repository.login(email, password);
      if (!success) {
        errorMessage = 'Email hoặc mật khẩu không đúng';
      }
      return success;
    } catch (e) {
      errorMessage = 'Có lỗi xảy ra khi đăng nhập';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
    required String confirmPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (fullName.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          birthDate.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        errorMessage = 'Vui lòng nhập đầy đủ thông tin';
        return false;
      }

      if (password != confirmPassword) {
        errorMessage = 'Mật khẩu xác nhận không khớp';
        return false;
      }

      final success = await repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        birthDate: birthDate,
        password: password,
      );

      if (!success) {
        errorMessage = 'Email đã tồn tại';
      }

      return success;
    } catch (e) {
      errorMessage = 'Có lỗi xảy ra khi đăng ký';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final exists = await repository.checkEmailExists(email);
      if (!exists) {
        errorMessage = 'Email không tồn tại';
        return false;
      }
      _resetEmail = email;
      return true;
    } catch (e) {
      errorMessage = 'Có lỗi xảy ra';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (_resetEmail == null) {
        errorMessage = 'Phiên đặt lại mật khẩu không hợp lệ';
        return false;
      }

      if (newPassword.isEmpty || confirmPassword.isEmpty) {
        errorMessage = 'Vui lòng nhập đầy đủ mật khẩu';
        return false;
      }

      if (newPassword != confirmPassword) {
        errorMessage = 'Mật khẩu xác nhận không khớp';
        return false;
      }

      return await repository.resetPassword(
        email: _resetEmail!,
        newPassword: newPassword,
      );
    } catch (e) {
      errorMessage = 'Không thể đổi mật khẩu';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
