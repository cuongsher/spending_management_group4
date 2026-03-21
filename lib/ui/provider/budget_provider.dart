import 'package:flutter/material.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../data/repository/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository repository;

  BudgetProvider(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<BudgetModel> budgets = [];
  Map<int, double> spentByCategory = {};
  BudgetDetailData? detail;

  Future<void> loadBudgets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      budgets = await repository.getBudgets();
      spentByCategory = await repository.getSpentByCategory();
    } catch (e) {
      errorMessage = 'Không thể tải danh sách hạn mức';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBudgetDetail(BudgetModel budget) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      detail = await repository.getBudgetDetail(budget);
    } catch (e) {
      errorMessage = 'Không thể tải chi tiết hạn mức';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBudget(BudgetModel budget) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.addBudget(budget);
      await loadBudgets();
      return true;
    } catch (e) {
      errorMessage = 'Không thể thêm hạn mức';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
