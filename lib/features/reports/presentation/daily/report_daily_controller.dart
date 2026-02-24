import 'package:flutter/material.dart';

import '../../../transactions/domain/models/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../models/report_summary.dart';

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
    debugPrint('REPORT all count = ${all.length}');
    debugPrint('REPORT day = ${day.day}/${day.month}/${day.year}');

    final filtered = all.where((e) =>
        e.date.year == day.year &&
        e.date.month == day.month &&
        e.date.day == day.day);

    int income = 0;
    int expense = 0;

    for (final tx in filtered) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    summary = ReportSummary(
      totalIncome: income,
      totalExpense: expense,
    );

    debugPrint('REPORT income=$income expense=$expense');

    isLoading = false;
    notifyListeners();
  }
}