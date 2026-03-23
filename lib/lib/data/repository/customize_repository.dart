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
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.startDate,
    required this.repeatCycle,
    required this.type,
    required this.note,
  });

  final int id;
  final int userId;
  final int categoryId;
  final String title;
  final double amount;
  final String startDate;
  final String repeatCycle;
  final String type;
  final String note;
}

class CustomizeRepository {
  CustomizeRepository(this.source);

  final CustomizeSource source;

  Future<CustomizeDashboardData> loadDashboard() async {
    final transactions = await source.getTransactions();
    double totalIncome = 0;
    double totalExpense = 0;

    for (final row in transactions) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num?)?.toDouble() ?? 0;
      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
    }

    final totalBalance = totalIncome - totalExpense;

    return CustomizeDashboardData(
      totalBalance: totalBalance,
      totalExpense: totalExpense,
      spendingProgress: totalIncome == 0
          ? 0
          : (totalExpense / totalIncome).clamp(0.0, 1.0),
    );
  }

  Future<List<CategoryModel>> getCategories({required String type}) {
    return source.getCategories(type: type);
  }

  Future<void> addCategory(CategoryModel model) {
    return source.addCategory(model);
  }

  Future<void> updateCategory(CategoryModel model) {
    return source.updateCategory(model);
  }

  Future<void> deleteCategory(int id) {
    return source.deleteCategory(id);
  }

  Future<List<ShoppingListModel>> getShoppingItems() {
    return source.getShoppingItems();
  }

  Future<void> addShoppingItem(ShoppingListModel model) {
    return source.addShoppingItem(model);
  }

  Future<void> updateShoppingItem(ShoppingListModel model) {
    return source.updateShoppingItem(model);
  }

  Future<void> deleteShoppingItem(int id) {
    return source.deleteShoppingItem(id);
  }

  Future<List<AssetModel>> getAssets() {
    return source.getAssets();
  }

  Future<void> addAsset(AssetModel model) {
    return source.addAsset(model);
  }

  Future<void> updateAsset(AssetModel model) {
    return source.updateAsset(model);
  }

  Future<void> deleteAsset(int id) {
    return source.deleteAsset(id);
  }

  Future<List<RecurringItem>> getRecurringTransactions({
    required String type,
  }) async {
    final rows = await source.getRecurringTransactions(type: type);
    return rows
        .map(
          (row) => RecurringItem(
            id: row['id'] as int,
            userId: row['user_id'] as int,
            categoryId: row['category_id'] as int,
            title: (row['category_name'] as String?) ?? 'Khác',
            amount: (row['amount'] as num?)?.toDouble() ?? 0,
            startDate: (row['start_date'] as String?) ?? '',
            repeatCycle: (row['repeat_cycle'] as String?) ?? '',
            type: (row['category_type'] as String?) ?? type,
            note: (row['note'] as String?) ?? '',
          ),
        )
        .toList();
  }

  Future<void> addRecurringTransaction(RecurringTransactionModel model) {
    return source.addRecurringTransaction(model);
  }

  Future<void> updateRecurringTransaction(RecurringTransactionModel model) {
    return source.updateRecurringTransaction(model);
  }

  Future<void> deleteRecurringTransaction(int id) {
    return source.deleteRecurringTransaction(id);
  }
}
