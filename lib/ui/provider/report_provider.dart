import 'package:flutter/material.dart';

import '../../data/repository/report_repository.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider(this.repository);

  final ReportRepository repository;

  bool isLoading = false;
  String? errorMessage;
  String selectedPeriod = 'month';
  ReportDashboardData? dashboard;

  Future<void> loadReport({String? period}) async {
    if (period != null) {
      selectedPeriod = period;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboard = await repository.loadReport(period: selectedPeriod);
    } catch (_) {
      errorMessage = 'Không thể tải báo cáo';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
