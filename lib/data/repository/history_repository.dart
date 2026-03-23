import '../database/models/TransactionModel.dart';
import '../sources/history_source.dart';

class HistoryTransactionItem {
  HistoryTransactionItem({
    required this.transaction,
    required this.title,
    required this.subtitle,
    required this.scheduleLabel,
    required this.amount,
    required this.isExpense,
    required this.rawDate,
  });

  final TransactionModel transaction;
  final String title;
  final String subtitle;
  final String scheduleLabel;
  final double amount;
  final bool isExpense;
  final DateTime rawDate;
}

class HistoryMonthSection {
  HistoryMonthSection({required this.title, required this.items});

  final String title;
  final List<HistoryTransactionItem> items;
}

class HistoryDashboardData {
  HistoryDashboardData({
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    required this.sections,
  });

  final double balance;
  final double totalIncome;
  final double totalExpense;
  final List<HistoryMonthSection> sections;
}

class HistoryRepository {
  HistoryRepository(this.source);

  final HistorySource source;

  Future<HistoryDashboardData> loadHistory({String filter = 'all'}) async {
    final rows = await source.getTransactionsWithCategory();

    double totalIncome = 0;
    double totalExpense = 0;
    final grouped = <String, List<HistoryTransactionItem>>{};

    for (final row in rows) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num?)?.toDouble() ?? 0;
      final rawDate =
          DateTime.tryParse((row['date'] as String?) ?? '') ??
          DateTime(2026, 1, 1);

      if (isExpense) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }

      if (filter == 'income' && isExpense) continue;
      if (filter == 'expense' && !isExpense) continue;

      final item = HistoryTransactionItem(
        transaction: TransactionModel(
          id: row['id'] as int?,
          userId: row['user_id'] as int? ?? 1,
          categoryId: row['category_id'] as int? ?? 0,
          type: (row['type'] as String?) ?? 'expense',
          amount: amount,
          date: (row['date'] as String?) ?? '',
          address: (row['address'] as String?) ?? '',
          note: (row['note'] as String?) ?? '',
        ),
        title: (row['category_name'] as String?) ?? 'Khác',
        subtitle: _formatDate(rawDate),
        scheduleLabel: _scheduleLabel(isExpense, rawDate),
        amount: amount,
        isExpense: isExpense,
        rawDate: rawDate,
      );

      final monthKey =
          '${rawDate.year}-${rawDate.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(monthKey, () => []).add(item);
    }

    final sections = grouped.entries.map((entry) {
      final parsedMonth =
          DateTime.tryParse('${entry.key}-01') ?? DateTime.now();
      return HistoryMonthSection(
        title: 'Tháng ${parsedMonth.month}',
        items: entry.value,
      );
    }).toList();

    return HistoryDashboardData(
      balance: totalIncome - totalExpense,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      sections: sections,
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _scheduleLabel(bool isExpense, DateTime date) {
    if (!isExpense) return 'Thu nhập';
    if (date.day <= 7) return 'Định kỳ';
    if (date.day <= 15) return 'Thi thoảng';
    return 'Thường xuyên';
  }
}
