import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class ReportSource {
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        t.id,
        t.type,
        t.amount,
        t.date,
        c.name AS category_name
      FROM TransactionTable t
      LEFT JOIN Category c ON c.id = t.category_id
      ORDER BY t.date ASC, t.id ASC
    ''');
  }
}
