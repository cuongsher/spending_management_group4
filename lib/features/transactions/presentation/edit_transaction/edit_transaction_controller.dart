import 'package:flutter/material.dart';
// ignore: unused_import
import '../../../transactions/data/repositories/transaction_repo_provider.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class EditTransactionController extends ChangeNotifier {
  final TransactionRepository _repo;
  final Transaction original;

  EditTransactionController(this._repo, this.original);

  bool isLoading = false;
  String? error;

  Future<bool> update({
    required TransactionType type,
    required String category,
    required int amount,
    required DateTime date,
    String? note,
  }) async {
    if (category.trim().isEmpty) {
      error = 'Hạng mục không được rỗng';
      notifyListeners();
      return false;
    }

    if (amount <= 0) {
      error = 'Số tiền phải > 0';
      notifyListeners();
      return false;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updated = original.copyWith(
        type: type,
        category: category,
        amount: amount,
        date: date,
        note: note,
        updatedAt: DateTime.now(),
      );

      await _repo.update(updated);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      error = 'Cập nhật thất bại';
      notifyListeners();
      return false;
    }
  }

  Future<void> delete() async {
    await _repo.deleteById(original.id);
  }
}
