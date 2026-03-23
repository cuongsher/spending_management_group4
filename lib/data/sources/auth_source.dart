import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/UserModel.dart';

class AuthSource {
  int? currentUserId;

  Future<UserModel?> login(String email, String password) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'User',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) return null;

    final user = UserModel.fromMap(result.first);
    currentUserId = user.id;
    return user;
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final existed = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existed.isNotEmpty) return false;

    final user = UserModel(
      fullName: fullName,
      email: email,
      phone: phone,
      birthDate: birthDate,
      password: password,
      createdAt: DateTime.now().toIso8601String(),
    );

    final id = await db.insert('User', user.toMap());
    currentUserId = id;
    return true;
  }

  Future<bool> checkEmailExists(String email) async {
    final Database db = await DatabaseHelper.instance.database;

    final result = await db.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final Database db = await DatabaseHelper.instance.database;

    final count = await db.update(
      'User',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );

    return count > 0;
  }

  void logout() {
    currentUserId = null;
  }
}
