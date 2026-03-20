import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../database/models/ShoppingListModel.dart';

class ShoppingListRepository {

  Future<List<ShoppingListModel>> getShoppingItems() async {

    final db = await DatabaseHelper.instance.database;

    final result = await db.query('ShoppingList');

    return result.map((e) => ShoppingListModel.fromMap(e)).toList();
  }

}