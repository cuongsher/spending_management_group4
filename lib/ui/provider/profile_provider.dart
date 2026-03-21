import 'package:flutter/material.dart';

import '../../data/database/models/UserModel.dart';
import '../../data/repository/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this.repository);

  final ProfileRepository repository;

  bool isLoading = false;
  String? errorMessage;
  UserModel? user;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool generalNotifications = true;
  bool soundEnabled = true;
  bool callNotifications = true;
  bool vibrationEnabled = true;
  bool transactionChanges = false;
  bool transactionNotifications = false;
  bool budgetWarnings = false;

  Future<void> loadProfile({int? userId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      user = userId == null
          ? await repository.getPrimaryUser()
          : await repository.getUserById(userId);
    } catch (_) {
      errorMessage = 'Không thể tải hồ sơ';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await repository.updateProfile(
        userId: userId,
        fullName: fullName,
        phone: phone,
        email: email,
      );
      if (success) {
        await loadProfile(userId: userId);
      } else {
        errorMessage = 'Không thể cập nhật thông tin';
      }
      return success;
    } catch (_) {
      errorMessage = 'Không thể cập nhật thông tin';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      if (newPassword != confirmPassword) {
        errorMessage = 'Mật khẩu xác nhận không khớp';
        return false;
      }
      final success = await repository.updatePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      if (!success) {
        errorMessage = 'Mật khẩu hiện tại không đúng';
      }
      return success;
    } catch (_) {
      errorMessage = 'Không thể đổi mật khẩu';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAccount({
    required int userId,
    required String password,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final success = await repository.deleteAccount(
        userId: userId,
        password: password,
      );
      if (!success) {
        errorMessage = 'Mật khẩu không đúng hoặc không thể xóa tài khoản';
      } else {
        user = null;
      }
      return success;
    } catch (_) {
      errorMessage = 'Không thể xóa tài khoản';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setNotificationsEnabled(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void setDarkModeEnabled(bool value) {
    darkModeEnabled = value;
    notifyListeners();
  }

  void setGeneralNotifications(bool value) {
    generalNotifications = value;
    notifyListeners();
  }

  void setSoundEnabled(bool value) {
    soundEnabled = value;
    notifyListeners();
  }

  void setCallNotifications(bool value) {
    callNotifications = value;
    notifyListeners();
  }

  void setVibrationEnabled(bool value) {
    vibrationEnabled = value;
    notifyListeners();
  }

  void setTransactionChanges(bool value) {
    transactionChanges = value;
    notifyListeners();
  }

  void setTransactionNotifications(bool value) {
    transactionNotifications = value;
    notifyListeners();
  }

  void setBudgetWarnings(bool value) {
    budgetWarnings = value;
    notifyListeners();
  }
}
