import '../database/models/BudgetModel.dart';
import '../sources/budget_source.dart';

class BudgetRepository {
  final BudgetSource source;

  BudgetRepository(this.source);

  Future<List<BudgetModel>> getBudgets() {
    return source.getBudgets();
  }

  Future<void> addBudget(BudgetModel budget) {
    return source.addBudget(budget);
  }
}