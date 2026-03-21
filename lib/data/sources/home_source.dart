import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/BudgetModel.dart';
import '../database/models/NotificationModel.dart';
import '../database/models/TransactionModel.dart';
import '../database/models/UserModel.dart';

class HomeSource {
  Future<UserModel?> getPrimaryUser() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('User', orderBy: 'id ASC', limit: 1);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<List<TransactionModel>> getRecentTransactions() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'TransactionTable',
      orderBy: 'id DESC',
      limit: 8,
    );
    return result.map(TransactionModel.fromMap).toList();
  }

  Future<List<Map<String, dynamic>>> getRecentTransactionsWithCategory() async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        t.id,
        t.type,
        t.amount,
        t.date,
        t.address,
        t.note,
        c.name AS category_name
      FROM TransactionTable t
      LEFT JOIN Category c ON c.id = t.category_id
      ORDER BY t.id DESC
      LIMIT 8
    ''');
  }

  Future<List<Map<String, dynamic>>> getExpenseBreakdown() async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        c.name AS category_name,
        SUM(t.amount) AS total_amount
      FROM TransactionTable t
      INNER JOIN Category c ON c.id = t.category_id
      WHERE t.type = 'expense'
      GROUP BY c.name
      ORDER BY total_amount DESC
    ''');
  }

  Future<List<BudgetModel>> getBudgets() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Budget', orderBy: 'id DESC', limit: 3);
    return result.map(BudgetModel.fromMap).toList();
  }

  Future<List<NotificationModel>> getUnreadNotifications() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Notification', orderBy: 'id DESC', limit: 4);
    return result.map(NotificationModel.fromMap).toList();
  }
}
