import '../database/models/CategoryModel.dart';
import '../database/models/TransactionModel.dart';
import '../sources/transaction_source.dart';

class TransactionRepository {
  TransactionRepository(this.source);

  final TransactionSource source;

  Future<List<CategoryModel>> getCategoriesByType(String type) {
    return source.getCategoriesByType(type);
  }

  Future<void> addTransaction(TransactionModel model) {
    return source.addTransaction(model);
  }

  Future<void> updateTransaction(TransactionModel model) {
    return source.updateTransaction(model);
  }

  Future<void> deleteTransaction(int id) {
    return source.deleteTransaction(id);
  }
}
