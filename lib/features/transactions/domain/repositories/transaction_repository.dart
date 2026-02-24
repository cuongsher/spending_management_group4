import '../models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getAll();

  Future<Transaction> add(Transaction transaction);

  Future<Transaction> update(Transaction transaction);

  Future<void> deleteById(String id);
}

/*Đây là xương sống kiến trúc

UI / Controller chỉ biết interface này

Sau này bạn tạo:
transaction_repo_sqlite.dart

transaction_repo_firebase.dart
➡️ KHÔNG sửa UI*/