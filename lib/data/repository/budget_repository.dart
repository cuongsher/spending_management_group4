import '../database/database_helper.dart';
import '../database/models/BudgetModel.dart';

class BudgetRepository {

  Future<List<BudgetModel>> getBudgets() async {

    final db = await DatabaseHelper.instance.database;

    final result = await db.query('Budget');

    return result.map((e) => BudgetModel.fromMap(e)).toList();
  }

}