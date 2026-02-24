import 'package:flutter/material.dart';
// ignore: unused_import
import '../../../transactions/data/repositories/transaction_repo_provider.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

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
    // VALIDATE
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
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        category: category,
        amount: amount,
        date: date,
        note: note,
        createdAt: DateTime.now(),
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
/* 🔎 Mentor note (rất quan trọng)

Controller KHÔNG chứa UI

Chỉ làm 3 việc:

validate

gọi repo

giữ state loading / error

Sau này Edit/Delete controller làm y hệt, chỉ đổi hàm gọi repo. */