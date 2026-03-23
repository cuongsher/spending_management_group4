import 'package:flutter/material.dart';

import '../../data/repository/history_repository.dart';

class HistoryProvider extends ChangeNotifier {
  HistoryProvider(this.repository);

  final HistoryRepository repository;

  bool isLoading = false;
  String? errorMessage;
  String selectedFilter = 'all';
  HistoryDashboardData? dashboard;

  Future<void> loadHistory({String? filter}) async {
    if (filter != null) {
      selectedFilter = filter;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboard = await repository.loadHistory(filter: selectedFilter);
    } catch (_) {
      errorMessage = 'Không thể tải lịch sử giao dịch';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
