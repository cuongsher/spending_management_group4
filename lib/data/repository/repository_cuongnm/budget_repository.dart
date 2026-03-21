import '../../database/model1/BudgetModel.dart';
import '../../sources_cuongnm/budget_source.dart';


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