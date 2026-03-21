import 'package:flutter/material.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/database/model1/report.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';


class ReportYearlyController extends ChangeNotifier {
  final TransactionRepository _repo;
  ReportYearlyController(this._repo);

  bool isLoading = false;
  ReportSummary? summary;

  Future<void> loadYear(int year) async {
    isLoading = true;
    summary = null;
    notifyListeners();

    final all = await _repo.getAll();

    // Bar: 5 năm gần nhất
    final barEntries = List.generate(5, (i) {
      final y = year - 4 + i;
      final txs = all.where((e) => e.date.year == y);
      final inc = txs.where((e) => e.type == TransactionType.income).fold(0, (s, e) => s + e.amount);
      final exp = txs.where((e) => e.type == TransactionType.expense).fold(0, (s, e) => s + e.amount);
      return BarEntry(label: '$y', income: inc, expense: exp);
    });

    final filtered = all.where((e) => e.date.year == year);
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
