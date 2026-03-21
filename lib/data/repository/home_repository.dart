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
    final transactions = await source.getRecentTransactionsWithCategory();
    final budgets = await source.getBudgets();
    final notifications = await source.getUnreadNotifications();
    final breakdownRows = await source.getExpenseBreakdown();

    double totalIncome = 0;
    double totalExpense = 0;

    final historyItems = <HomeHistoryItem>[];
    for (final row in transactions) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num).toDouble();
      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
      historyItems.add(
        HomeHistoryItem(
          title: (row['category_name'] as String?) ?? 'Khác',
          subtitle: (row['date'] as String?) ?? '',
          periodLabel: isExpense ? 'Chi tiêu' : 'Thu nhập',
          amount: amount,
          isExpense: isExpense,
        ),
      );
    }

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
      historyItems: historyItems.take(3).toList(),
      budgets: budgets,
      breakdown: breakdown.take(4).toList(),
      notifications: notifications,
    );
  }
}
