import '../database/models/BudgetModel.dart';
import '../database/models/CategoryModel.dart';
import '../sources/budget_source.dart';

class BudgetExpenseItem {
  BudgetExpenseItem({
    required this.amount,
    required this.date,
    required this.note,
    required this.address,
  });

  final double amount;
  final String date;
  final String note;
  final String address;
}

class BudgetDetailData {
  BudgetDetailData({
    required this.categoryName,
    required this.spentAmount,
    required this.progress,
    required this.expenses,
  });

  final String categoryName;
  final double spentAmount;
  final double progress;
  final List<BudgetExpenseItem> expenses;
}

class BudgetRepository {
  final BudgetSource source;

  BudgetRepository(this.source);

  Future<List<BudgetModel>> getBudgets() {
    return source.getBudgets();
  }

  Future<void> addBudget(BudgetModel budget) {
    return source.addBudget(budget);
  }

  Future<void> updateBudget(BudgetModel budget) {
    return source.updateBudget(budget);
  }

  Future<void> deleteBudget(int id) {
    return source.deleteBudget(id);
  }

  Future<List<CategoryModel>> getExpenseCategories() {
    return source.getExpenseCategories();
  }

  Future<Map<int, double>> getSpentByCategory() {
    return source.getSpentByCategory();
  }

  Future<BudgetDetailData> getBudgetDetail(BudgetModel budget) async {
    final categoryName =
        await source.getCategoryName(budget.categoryId) ?? budget.budgetName;
    final expenseRows = await source.getBudgetExpenseItems(budget);
    final expenses = expenseRows
        .map(
          (row) => BudgetExpenseItem(
            amount: ((row['amount'] as num?) ?? 0).toDouble(),
            date: (row['date'] as String?) ?? '',
            note: (row['note'] as String?) ?? categoryName,
            address: (row['address'] as String?) ?? '',
          ),
        )
        .toList();
    final spentAmount = expenses.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );

    return BudgetDetailData(
      categoryName: categoryName,
      spentAmount: spentAmount,
      progress: budget.amount <= 0
          ? 0
          : (spentAmount / budget.amount).clamp(0.0, 1.0),
      expenses: expenses,
    );
  }
}
