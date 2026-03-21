import 'package:flutter/material.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/database/model1/report.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';


class ReportWeeklyController extends ChangeNotifier {
  final TransactionRepository _repo;
  ReportWeeklyController(this._repo);

  bool isLoading = false;
  ReportSummary? summary;

  Future<void> loadWeek(DateTime anyDayInWeek) async {
    isLoading = true;
    summary = null;
    notifyListeners();

    final all = await _repo.getAll();
    final (start, end) = _weekRange(anyDayInWeek);

    // Bar: 4 tuần gần nhất tính từ tuần hiện tại
    final barEntries = List.generate(4, (i) {
      final wStart = start.subtract(Duration(days: 7 * (3 - i)));
      final wEnd = wStart.add(const Duration(days: 6));
      final txs = all.where((e) => !_beforeDay(e.date, wStart) && !_afterDay(e.date, wEnd));
      final inc = txs.where((e) => e.type == TransactionType.income).fold(0, (s, e) => s + e.amount);
      final exp = txs.where((e) => e.type == TransactionType.expense).fold(0, (s, e) => s + e.amount);
      return BarEntry(label: 'Tuần ${i + 1}', income: inc, expense: exp);
    });

    final filtered = all.where((e) => !_beforeDay(e.date, start) && !_afterDay(e.date, end));
    int income = 0, expense = 0;
    final catMap = <String, int>{};
    for (final tx in filtered) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
        catMap[tx.category] = (catMap[tx.category] ?? 0) + tx.amount;
      }
    }

    summary = ReportSummary(
      totalIncome: income,
      totalExpense: expense,
      barEntries: barEntries,
      categoryEntries: catMap.entries.map((e) => CategoryEntry(category: e.key, amount: e.value)).toList()
        ..sort((a, b) => b.amount.compareTo(a.amount)),
    );
    isLoading = false;
    notifyListeners();
  }

  (DateTime, DateTime) _weekRange(DateTime d) {
    final day = DateTime(d.year, d.month, d.day);
    final mon = day.subtract(Duration(days: day.weekday - DateTime.monday));
    return (mon, mon.add(const Duration(days: 6)));
  }

  bool _beforeDay(DateTime a, DateTime b) =>
      DateTime(a.year, a.month, a.day).isBefore(DateTime(b.year, b.month, b.day));
  bool _afterDay(DateTime a, DateTime b) =>
      DateTime(a.year, a.month, a.day).isAfter(DateTime(b.year, b.month, b.day));
}
