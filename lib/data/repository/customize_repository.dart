import '../database/models/AssetModel.dart';
import '../database/models/CategoryModel.dart';
import '../database/models/RecurringTransactionModel.dart';
import '../database/models/ShoppingListModel.dart';
import '../sources/customize_source.dart';

class CustomizeDashboardData {
  CustomizeDashboardData({
    required this.totalBalance,
    required this.totalExpense,
    required this.spendingProgress,
  });

  final double totalBalance;
  final double totalExpense;
  final double spendingProgress;
}

class RecurringItem {
  RecurringItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.startDate,
    required this.repeatCycle,
    required this.type,
  });

  final int id;
  final String title;
  final double amount;
  final String startDate;
  final String repeatCycle;
  final String type;
}

class CustomizeRepository {
  CustomizeRepository(this.source);

  final CustomizeSource source;

  Future<CustomizeDashboardData> loadDashboard() async {
    final expenseCategories = await source.getCategories(type: 'expense');
    final assets = await source.getAssets();
    final totalBalance = assets.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final totalExpense = expenseCategories.length * 100.0;

    return CustomizeDashboardData(
      totalBalance: totalBalance,
      totalExpense: totalExpense,
      spendingProgress: totalBalance == 0
          ? 0
          : (totalExpense / totalBalance).clamp(0.0, 1.0),
    );
  }

  Future<List<CategoryModel>> getCategories({required String type}) {
    return source.getCategories(type: type);
  }

  Future<List<ShoppingListModel>> getShoppingItems() {
    return source.getShoppingItems();
  }

  Future<List<AssetModel>> getAssets() {
    return source.getAssets();
  }

  Future<List<RecurringItem>> getRecurringTransactions({
    required String type,
  }) async {
    final rows = await source.getRecurringTransactions(type: type);
    return rows
        .map(
          (row) => RecurringItem(
            id: row['id'] as int,
            title: (row['category_name'] as String?) ?? 'Khác',
            amount: (row['amount'] as num?)?.toDouble() ?? 0,
            startDate: (row['start_date'] as String?) ?? '',
            repeatCycle: (row['repeat_cycle'] as String?) ?? '',
            type: (row['category_type'] as String?) ?? type,
          ),
        )
        .toList();
  }

  Future<void> addRecurringTransaction(RecurringTransactionModel model) {
    return source.addRecurringTransaction(model);
  }
}
