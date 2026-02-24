import 'package:flutter/material.dart';

import '../../../transactions/domain/models/transaction.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../models/report_summary.dart';

class ReportWeeklyController extends ChangeNotifier {
  final TransactionRepository _repo;

  ReportWeeklyController(this._repo);

  bool isLoading = false;
  ReportSummary? summary;

  Future<void> loadWeek(DateTime anyDayInWeek) async {
    isLoading = true;
    summary = null;
    notifyListeners();

    final range = _weekRange(anyDayInWeek);
    final start = range.$1;
    final end = range.$2; // inclusive

    final all = await _repo.getAll();

    final filtered = all.where((e) => !_isBeforeDay(e.date, start) && !_isAfterDay(e.date, end));

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

  /// Trả về (monday, sunday) của tuần chứa anyDayInWeek
  (DateTime, DateTime) _weekRange(DateTime anyDayInWeek) {
    final d = DateTime(anyDayInWeek.year, anyDayInWeek.month, anyDayInWeek.day);
    // weekday: Mon=1 ... Sun=7
    final monday = d.subtract(Duration(days: d.weekday - DateTime.monday));
    final sunday = monday.add(const Duration(days: 6));
    return (monday, sunday);
  }

  bool _isBeforeDay(DateTime a, DateTime b) {
    final aa = DateTime(a.year, a.month, a.day);
    final bb = DateTime(b.year, b.month, b.day);
    return aa.isBefore(bb);
  }

  bool _isAfterDay(DateTime a, DateTime b) {
    final aa = DateTime(a.year, a.month, a.day);
    final bb = DateTime(b.year, b.month, b.day);
    return aa.isAfter(bb);
  }
}