import '../database/database_helper.dart';
import '../database/models/CategoryModel.dart';
import '../database/models/TransactionModel.dart';

class TransactionSource {
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'Category',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'name ASC',
    );
    return result.map(CategoryModel.fromMap).toList();
  }

  Future<void> addTransaction(TransactionModel model) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('TransactionTable', model.toMap());
  }

  Future<void> updateTransaction(TransactionModel model) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'TransactionTable',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'TransactionTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
