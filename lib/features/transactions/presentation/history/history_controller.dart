import 'package:flutter/material.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
// ignore: unused_import
import '../../../transactions/data/repositories/transaction_repo_provider.dart';

enum HistoryFilter {
  all,
  income,
  expense,
}

class HistoryController extends ChangeNotifier {
  final TransactionRepository _repo;

  HistoryController(this._repo);

  List<Transaction> _all = [];
  HistoryFilter filter = HistoryFilter.all;

  bool isLoading = false;
  String? error;

  List<Transaction> get items {
    switch (filter) {
      case HistoryFilter.income:
        return _all
            .where((e) => e.type == TransactionType.income)
            .toList();
      case HistoryFilter.expense:
        return _all
            .where((e) => e.type == TransactionType.expense)
            .toList();
      case HistoryFilter.all:
      return _all;
    }
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _all = await _repo.getAll();
    } catch (e) {
      error = 'Không tải được dữ liệu';
    }

    isLoading = false;
    notifyListeners();
  }

  void changeFilter(HistoryFilter value) {
    filter = value;
    notifyListeners();
  }
}
