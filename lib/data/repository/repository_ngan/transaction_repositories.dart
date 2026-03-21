import '../../database/model1/TransactionModel.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAll();
  Future<Transaction?> getById(String id);
  Future<void> add(Transaction transaction);
  Future<void> update(Transaction transaction);
  Future<void> delete(String id);
}