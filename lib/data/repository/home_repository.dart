import '../database/models/BudgetModel.dart';
import '../database/models/NotificationModel.dart';
import '../database/models/UserModel.dart';
import '../sources/home_source.dart';

class HomeHistoryItem {
  HomeHistoryItem({
    required this.title,
    required this.subtitle,
    required this.periodLabel,
    required this.amount,
    required this.isExpense,
  });

  final String title;
  final String subtitle;
  final String periodLabel;
  final double amount;
  final bool isExpense;
}

class CategoryBreakdownItem {
  CategoryBreakdownItem({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  final String name;
  final double amount;
  final double percentage;
}

class HomeDashboardData {
  HomeDashboardData({
    required this.user,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.historyItems,
    required this.budgets,
    required this.breakdown,
    required this.notifications,
  });

  final UserModel? user;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<HomeHistoryItem> historyItems;
  final List<BudgetModel> budgets;
  final List<CategoryBreakdownItem> breakdown;
  final List<NotificationModel> notifications;
}

class HomeRepository {
  HomeRepository(this.source);

  final HomeSource source;

  Future<HomeDashboardData> loadDashboard() async {
    final user = await source.getPrimaryUser();
    final allTransactions = await source.getTransactionsWithCategory();
    final recentTransactions = await source.getTransactionsWithCategory(limit: 3);
    final budgets = await source.getBudgets(limit: 3);
    final notifications = await source.getUnreadNotifications();
    final breakdownRows = await source.getExpenseBreakdown();

    double totalIncome = 0;
    double totalExpense = 0;

    for (final row in allTransactions) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num).toDouble();
      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
    }

    final historyItems = recentTransactions.map((row) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num).toDouble();
      return HomeHistoryItem(
        title: (row['category_name'] as String?) ?? 'Khác',
        subtitle: (row['date'] as String?) ?? '',
        periodLabel: isExpense ? 'Chi tiêu' : 'Thu nhập',
        amount: amount,
        isExpense: isExpense,
      );
    }).toList();

    final totalExpenseAmount = breakdownRows.fold<double>(
      0,
      (sum, row) => sum + ((row['total_amount'] as num?)?.toDouble() ?? 0),
    );

    final breakdown = breakdownRows.map((row) {
      final amount = (row['total_amount'] as num?)?.toDouble() ?? 0;
      final percentage = totalExpenseAmount == 0
          ? 0.0
          : ((amount / totalExpenseAmount) * 100).toDouble();
      return CategoryBreakdownItem(
        name: (row['category_name'] as String?) ?? 'Khác',
        amount: amount,
        percentage: percentage,
      );
    }).toList();

    return HomeDashboardData(
      user: user,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
      historyItems: historyItems,
      budgets: budgets,
      breakdown: breakdown.take(4).toList(),
      notifications: notifications,
    );
  }
}
