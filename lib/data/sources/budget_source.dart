import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/BudgetModel.dart';

class BudgetSource {
  Future<List<BudgetModel>> getBudgets() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Budget', orderBy: 'id DESC');

    return result.map((e) => BudgetModel.fromMap(e)).toList();
  }

  Future<void> addBudget(BudgetModel budget) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('Budget', budget.toMap());
  }

  Future<Map<int, double>> getSpentByCategory() async {
    final Database db = await DatabaseHelper.instance.database;
    final rows = await db.rawQuery('''
      SELECT category_id, SUM(amount) AS spent_amount
      FROM TransactionTable
      WHERE type = 'expense'
      GROUP BY category_id
    ''');

    return {
      for (final row in rows)
        (row['category_id'] as int): ((row['spent_amount'] as num?) ?? 0).toDouble(),
    };
  }

  Future<String?> getCategoryName(int categoryId) async {
    final Database db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'Category',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [categoryId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['name'] as String?;
  }

  Future<List<Map<String, dynamic>>> getBudgetExpenseItems(BudgetModel budget) async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        t.id,
        t.amount,
        t.date,
        t.address,
        t.note,
        c.name AS category_name
      FROM TransactionTable t
      LEFT JOIN Category c ON c.id = t.category_id
      WHERE t.user_id = ?
        AND t.category_id = ?
        AND t.type = 'expense'
      ORDER BY t.date DESC, t.id DESC
    ''', [budget.userId, budget.categoryId]);
  }
}
