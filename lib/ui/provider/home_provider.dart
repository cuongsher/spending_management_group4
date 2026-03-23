import 'package:flutter/material.dart';

import '../../data/repository/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(this.repository);

  final HomeRepository repository;

  bool isLoading = false;
  String? errorMessage;
  HomeDashboardData? dashboard;

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboard = await repository.loadDashboard();
    } catch (e) {
      errorMessage = 'Không thể tải dữ liệu trang chủ';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
