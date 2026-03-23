import '../sources/report_source.dart';

class ReportBarItem {
  ReportBarItem({
    required this.label,
    required this.income,
    required this.expense,
  });

  final String label;
  final double income;
  final double expense;
}

class ReportPieItem {
  ReportPieItem({
    required this.name,
    required this.amount,
    required this.percentage,
  });

  final String name;
  final double amount;
  final double percentage;
}

class ReportDashboardData {
  ReportDashboardData({
    required this.totalIncome,
    required this.totalExpense,
    required this.progress,
    required this.bars,
    required this.breakdown,
  });

  final double totalIncome;
  final double totalExpense;
  final double progress;
  final List<ReportBarItem> bars;
  final List<ReportPieItem> breakdown;
}

class ReportRepository {
  ReportRepository(this.source);

  final ReportSource source;

  Future<ReportDashboardData> loadReport({String period = 'month'}) async {
    final rows = await source.getTransactionsWithCategory();

    final groupedBars = <String, _BarAccumulator>{};
    final groupedPie = <String, double>{};
    double totalIncome = 0;
    double totalExpense = 0;

    for (final row in rows) {
      final isExpense = row['type'] == 'expense';
      final amount = (row['amount'] as num?)?.toDouble() ?? 0;
      final date =
          DateTime.tryParse((row['date'] as String?) ?? '') ??
          DateTime(2026, 1, 1);

      final barKey = _groupKey(period, date);
      final barLabel = _groupLabel(period, date);
      final bar = groupedBars.putIfAbsent(
        barKey,
        () => _BarAccumulator(label: barLabel),
      );

      if (isExpense) {
        bar.expense += amount;
        totalExpense += amount;
        final categoryName = (row['category_name'] as String?) ?? 'Khác';
        groupedPie[categoryName] = (groupedPie[categoryName] ?? 0) + amount;
      } else {
        bar.income += amount;
        totalIncome += amount;
      }
    }

    final totalPie = groupedPie.values.fold<double>(
      0,
      (sum, item) => sum + item,
    );
    final breakdown = groupedPie.entries.map((entry) {
      final percentage = totalPie == 0 ? 0.0 : (entry.value / totalPie) * 100;
      return ReportPieItem(
        name: entry.key,
        amount: entry.value,
        percentage: percentage,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

    final bars = groupedBars.values
        .map(
          (item) => ReportBarItem(
            label: item.label,
            income: item.income,
            expense: item.expense,
          ),
        )
        .toList();

    return ReportDashboardData(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      progress: totalIncome == 0
          ? 0
          : (totalExpense / totalIncome).clamp(0.0, 1.0),
      bars: bars,
      breakdown: breakdown.take(4).toList(),
    );
  }

  String _groupKey(String period, DateTime date) {
    switch (period) {
      case 'day':
        return '${date.year}-${date.month}-${date.day}';
      case 'week':
        final week = ((date.day - 1) ~/ 7) + 1;
        return '${date.year}-${date.month}-w$week';
      case 'year':
        return '${date.year}';
      case 'month':
      default:
        return '${date.year}-${date.month}';
    }
  }

  String _groupLabel(String period, DateTime date) {
    switch (period) {
      case 'day':
        return 'T${date.weekday}';
      case 'week':
        return 'Tuần ${((date.day - 1) ~/ 7) + 1}';
      case 'year':
        return '${date.year}';
      case 'month':
      default:
        return 'T${date.month}';
    }
  }
}

class _BarAccumulator {
  _BarAccumulator({required this.label});

  final String label;
  double income = 0;
  double expense = 0;
}
