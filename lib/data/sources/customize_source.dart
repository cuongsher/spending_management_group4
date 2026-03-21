import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/AssetModel.dart';
import '../database/models/CategoryModel.dart';
import '../database/models/RecurringTransactionModel.dart';
import '../database/models/ShoppingListModel.dart';

class CustomizeSource {
  Future<List<CategoryModel>> getCategories({String? type}) async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'Category',
      where: type == null ? null : 'type = ?',
      whereArgs: type == null ? null : [type],
      orderBy: 'name ASC',
    );
    return result.map(CategoryModel.fromMap).toList();
  }

  Future<List<ShoppingListModel>> getShoppingItems() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('ShoppingList', orderBy: 'id DESC');
    return result.map(ShoppingListModel.fromMap).toList();
  }

  Future<List<AssetModel>> getAssets() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Asset', orderBy: 'id DESC');
    return result.map(AssetModel.fromMap).toList();
  }

  Future<List<Map<String, dynamic>>> getRecurringTransactions({
    String? type,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        r.id,
        r.amount,
        r.start_date,
        r.repeat_cycle,
        r.note,
        c.name AS category_name,
        c.type AS category_type
      FROM RecurringTransaction r
      LEFT JOIN Category c ON c.id = r.category_id
      ${type == null ? '' : "WHERE c.type = ?"}
      ORDER BY r.id DESC
    ''', type == null ? [] : [type]);
  }

  Future<void> addRecurringTransaction(RecurringTransactionModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('RecurringTransaction', model.toMap());
  }
}
