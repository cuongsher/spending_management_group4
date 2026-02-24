import 'package:flutter/material.dart';

import '../../../transactions/domain/models/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../models/report_summary.dart';


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

    final filtered = all.where((e) => e.date.year == year && e.date.month == month);

    int income = 0;
    int expense = 0;

    for (final tx in filtered) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    summary = ReportSummary(totalIncome: income, totalExpense: expense);
    isLoading = false;
    notifyListeners();
  }
}