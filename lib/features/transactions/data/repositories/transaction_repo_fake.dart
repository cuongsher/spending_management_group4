import 'dart:math';

import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepoFake implements TransactionRepository {
  final List<Transaction> _store = [];

  TransactionRepoFake() {
    if (_store.isEmpty) {
    _seedData();
    }
  }

  void _seedData() {
    _store.addAll([
      Transaction(
        id: _genId(),
        type: TransactionType.expense,
        category: 'Ăn uống',
        amount: 74040,
        date: DateTime.now().subtract(const Duration(days: 1)),
        note: 'Dinner',
        createdAt: DateTime.now(),
      ),
      Transaction(
        id: _genId(),
        type: TransactionType.expense,
        category: 'Giao thông',
        amount: 4130,
        date: DateTime.now().subtract(const Duration(days: 2)),
        note: 'Bus',
        createdAt: DateTime.now(),
      ),
      Transaction(
        id: _genId(),
        type: TransactionType.income,
        category: 'Lương',
        amount: 4000000,
        date: DateTime.now().subtract(const Duration(days: 3)),
        note: 'Salary',
        createdAt: DateTime.now(),
      ),
    ]);
  }

  String _genId() {
    final rnd = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() +
        rnd.nextInt(999).toString();
  }

  @override
  Future<List<Transaction>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List<Transaction>.from(_store);
  }

  @override
  Future<Transaction> add(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _store.add(transaction);
    return transaction;
  }

  @override
  Future<Transaction> update(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _store.indexWhere((e) => e.id == transaction.id);
    if (index == -1) {
      throw Exception('Transaction not found');
    }

    _store[index] = transaction.copyWith(
      updatedAt: DateTime.now(),
    );

    return _store[index];
  }

  @override
  Future<void> deleteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _store.removeWhere((e) => e.id == id);
  }
}
