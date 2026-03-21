import 'package:flutter/material.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../data/repository/repository_ngan/transaction_repositories.dart';

class AddTransactionController extends ChangeNotifier {
  final TransactionRepository _repo;

  AddTransactionController(this._repo);

  bool isLoading = false;
  String? error;

  Future<bool> submit({
    required TransactionType type,
    required String category,
    required int amount,
    required DateTime date,
    String? note,
  }) async {
    if (category.trim().isEmpty) {
      error = 'Vui lòng nhập hạng mục';
      notifyListeners();
      return false;
    }

    if (amount <= 0) {
      error = 'Số tiền phải lớn hơn 0';
      notifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final transaction = Transaction(
        id: now.millisecondsSinceEpoch.toString(),
        type: type,
        category: category,
        amount: amount,
        date: date,
        note: note,
        createdAt: now,
        updatedAt: now, // Đã thêm dòng này để sửa lỗi "Add 1 required argument"
      );

      await _repo.add(transaction);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = 'Lưu giao dịch thất bại';
      notifyListeners();
      return false;
    }
  }
}