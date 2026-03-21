import 'package:flutter/material.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/database/model1/report.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';


class ReportDailyController extends ChangeNotifier {
  final TransactionRepository _repo;
  ReportDailyController(this._repo);

  bool isLoading = false;
  ReportSummary? summary;

  Future<void> load(DateTime day) async {
    isLoading = true;
    summary = null;
    notifyListeners();

    final all = await _repo.getAll();

    // Bar: 7 ngày trong tuần chứa day
    final weekStart = day.subtract(Duration(days: day.weekday - 1));
    final barEntries = List.generate(7, (i) {
      final d = weekStart.add(Duration(days: i));
      final txs = all.where((e) =>
      e.date.year == d.year && e.date.month == d.month && e.date.day == d.day);
      final inc = txs.where((e) => e.type == TransactionType.income).fold(0, (s, e) => s + e.amount);
      final exp = txs.where((e) => e.type == TransactionType.expense).fold(0, (s, e) => s + e.amount);
      const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
      return BarEntry(label: labels[i], income: inc, expense: exp);
    });

    // Tổng ngày được chọn
    final filtered = all.where((e) =>
    e.date.year == day.year && e.date.month == day.month && e.date.day == day.day);
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
}
