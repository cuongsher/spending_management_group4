import 'package:flutter/material.dart';

import '../../data/database/model1/BudgetModel.dart';
import '../../data/repository/repository_cuongnm/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository repository;

  BudgetProvider(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<BudgetModel> budgets = [];

  Future<void> loadBudgets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      budgets = await repository.getBudgets();
    } catch (e) {
      errorMessage = 'Không thể tải danh sách hạn mức';
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
