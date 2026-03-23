import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';

class HistorySource {
  Future<List<Map<String, dynamic>>> getTransactionsWithCategory() async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        t.id,
        t.user_id,
        t.category_id,
        t.type,
        t.amount,
        t.date,
        t.address,
        t.note,
        c.name AS category_name
      FROM TransactionTable t
      LEFT JOIN Category c ON c.id = t.category_id
      ORDER BY t.date DESC, t.id DESC
    ''');
  }
}
