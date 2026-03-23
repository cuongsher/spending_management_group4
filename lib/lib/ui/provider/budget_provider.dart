import 'package:flutter/material.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../data/database/models/CategoryModel.dart';
import '../../data/repository/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository repository;

  BudgetProvider(this.repository);

  bool isLoading = false;
  String? errorMessage;
  List<BudgetModel> budgets = [];
  List<CategoryModel> expenseCategories = [];
  Map<int, double> spentByCategory = {};
  BudgetDetailData? detail;

  Future<void> loadBudgets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      budgets = await repository.getBudgets();
      expenseCategories = await repository.getExpenseCategories();
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

  Future<bool> updateBudget(BudgetModel budget) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.updateBudget(budget);
      await loadBudgets();
      return true;
    } catch (e) {
      errorMessage = 'Không thể cập nhật hạn mức';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteBudget(int id) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.deleteBudget(id);
      await loadBudgets();
      return true;
    } catch (e) {
      errorMessage = 'Không thể xóa hạn mức';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
