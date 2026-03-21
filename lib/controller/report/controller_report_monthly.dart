import 'package:flutter/material.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/database/model1/report.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';


class ReportMonthlyController extends ChangeNotifier {
  final TransactionRepository _repo;
  ReportMonthlyController(this._repo);

  bool isLoading = false;
  ReportSummary? summary;

  Future<void> loadMonth({required int year, required int month}) async {
    isLoading = true;
    summary = null;
    notifyListeners();

    final all = await _repo.getAll();

    // Bar: 6 tháng gần nhất
    final barEntries = List.generate(6, (i) {
      int m = month - 5 + i;
      int y = year;
      while (m <= 0) { m += 12; y--; }
      while (m > 12) { m -= 12; y++; }
      final txs = all.where((e) => e.date.year == y && e.date.month == m);
      final inc = txs.where((e) => e.type == TransactionType.income).fold(0, (s, e) => s + e.amount);
      final exp = txs.where((e) => e.type == TransactionType.expense).fold(0, (s, e) => s + e.amount);
      return BarEntry(label: 'T$m', income: inc, expense: exp);
    });

    final filtered = all.where((e) => e.date.year == year && e.date.month == month);
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
