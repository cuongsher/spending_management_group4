import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/UserModel.dart';

class ProfileSource {
  Future<UserModel?> getUserById(int userId) async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'User',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getPrimaryUser() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('User', orderBy: 'id ASC', limit: 1);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<bool> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    final updated = await db.update(
      'User',
      {'full_name': fullName, 'phone': phone, 'email': email},
      where: 'id = ?',
      whereArgs: [userId],
    );
    return updated > 0;
  }

  Future<bool> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    final matched = await db.query(
      'User',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, currentPassword],
      limit: 1,
    );
    if (matched.isEmpty) return false;

    final updated = await db.update(
      'User',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [userId],
    );
    return updated > 0;
  }

  Future<bool> deleteAccount({
    required int userId,
    required String password,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    final matched = await db.query(
      'User',
      where: 'id = ? AND password = ?',
      whereArgs: [userId, password],
      limit: 1,
    );
    if (matched.isEmpty) return false;

    await db.delete('Notification', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(
      'TransactionTable',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    await db.delete('Budget', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(
      'RecurringTransaction',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    await db.delete('Asset', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('ShoppingList', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('Category', where: 'user_id = ?', whereArgs: [userId]);
    final deleted = await db.delete(
      'User',
      where: 'id = ?',
      whereArgs: [userId],
    );
    return deleted > 0;
  }
}
