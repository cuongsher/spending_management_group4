import 'package:flutter/material.dart';

import '../../data/database/models/CategoryModel.dart';
import '../../data/database/models/TransactionModel.dart';
import '../../data/repository/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider(this.repository);

  final TransactionRepository repository;

  bool isLoading = false;
  String? errorMessage;
  String selectedType = 'expense';
  List<CategoryModel> categories = [];

  Future<void> loadCategories({String? type}) async {
    if (type != null) {
      selectedType = type;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await repository.getCategoriesByType(selectedType);
    } catch (_) {
      errorMessage = 'Không thể tải danh mục';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTransaction(TransactionModel model) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await repository.addTransaction(model);
      return true;
    } catch (_) {
      errorMessage = 'Không thể lưu ghi chép';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
