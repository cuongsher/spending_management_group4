import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../database/models/AssetModel.dart';
import '../database/models/CategoryModel.dart';
import '../database/models/RecurringTransactionModel.dart';
import '../database/models/ShoppingListModel.dart';

class CustomizeSource {
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final Database db = await DatabaseHelper.instance.database;
    return db.query('TransactionTable', orderBy: 'date DESC, id DESC');
  }

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

  Future<void> addCategory(CategoryModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('Category', model.toMap());
  }

  Future<void> updateCategory(CategoryModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'Category',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Category', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ShoppingListModel>> getShoppingItems() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('ShoppingList', orderBy: 'id DESC');
    return result.map(ShoppingListModel.fromMap).toList();
  }

  Future<void> addShoppingItem(ShoppingListModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('ShoppingList', model.toMap());
  }

  Future<void> updateShoppingItem(ShoppingListModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'ShoppingList',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteShoppingItem(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('ShoppingList', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<AssetModel>> getAssets() async {
    final Database db = await DatabaseHelper.instance.database;
    final result = await db.query('Asset', orderBy: 'id DESC');
    return result.map(AssetModel.fromMap).toList();
  }

  Future<void> addAsset(AssetModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.insert('Asset', model.toMap());
  }

  Future<void> updateAsset(AssetModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update('Asset', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  Future<void> deleteAsset(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('Asset', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getRecurringTransactions({
    String? type,
  }) async {
    final Database db = await DatabaseHelper.instance.database;
    return db.rawQuery('''
      SELECT
        r.id,
        r.user_id,
        r.category_id,
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

  Future<void> updateRecurringTransaction(RecurringTransactionModel model) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.update(
      'RecurringTransaction',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteRecurringTransaction(int id) async {
    final Database db = await DatabaseHelper.instance.database;
    await db.delete('RecurringTransaction', where: 'id = ?', whereArgs: [id]);
  }
}
