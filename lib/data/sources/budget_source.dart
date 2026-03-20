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
}