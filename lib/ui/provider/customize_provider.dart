import 'package:flutter/material.dart';

import '../../data/database/models/AssetModel.dart';
import '../../data/database/models/CategoryModel.dart';
import '../../data/database/models/RecurringTransactionModel.dart';
import '../../data/database/models/ShoppingListModel.dart';
import '../../data/repository/customize_repository.dart';

class CustomizeProvider extends ChangeNotifier {
  CustomizeProvider(this.repository);

  final CustomizeRepository repository;

  bool isLoading = false;
  String? errorMessage;
  CustomizeDashboardData? dashboard;
  List<CategoryModel> categories = [];
  List<ShoppingListModel> shoppingItems = [];
  List<AssetModel> assets = [];
  List<RecurringItem> recurringItems = [];
  String selectedCategoryType = 'expense';
  String selectedRecurringType = 'expense';

  Future<void> loadDashboard() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      dashboard = await repository.loadDashboard();
    } catch (_) {
      errorMessage = 'Không thể tải màn tùy chỉnh';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCategories({String? type}) async {
    if (type != null) {
      selectedCategoryType = type;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await repository.getCategories(type: selectedCategoryType);
    } catch (_) {
      errorMessage = 'Không thể tải hạng mục';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadShoppingItems() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      shoppingItems = await repository.getShoppingItems();
    } catch (_) {
      errorMessage = 'Không thể tải danh sách mua sắm';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAssets() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      assets = await repository.getAssets();
    } catch (_) {
      errorMessage = 'Không thể tải tài sản';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecurringItems({String? type}) async {
    if (type != null) {
      selectedRecurringType = type;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      recurringItems = await repository.getRecurringTransactions(
        type: selectedRecurringType,
      );
    } catch (_) {
      errorMessage = 'Không thể tải thu chi định kỳ';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addRecurringTransaction(RecurringTransactionModel model) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.addRecurringTransaction(model);
      await loadRecurringItems(type: selectedRecurringType);
      return true;
    } catch (_) {
      errorMessage = 'Không thể thêm khoản định kỳ';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
