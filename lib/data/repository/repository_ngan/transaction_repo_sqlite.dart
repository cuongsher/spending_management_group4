import 'package:sqflite/sqflite.dart' hide Transaction;
import '../../database/database.dart';
import 'transaction_repositories.dart';
import '../../database/model1/TransactionModel.dart';


class TransactionRepoSqlite implements TransactionRepository {
  final AppDatabase _db;

  TransactionRepoSqlite(this._db);

  @override
  Future<List<Transaction>> getAll() async {
    final rows = await _db.db.query(
      AppDatabase.transactionTable,
      orderBy: 'date DESC',
    );
    return rows.map((row) => Transaction.fromMap(row)).toList();
  }

  @override
  Future<Transaction?> getById(String id) async {
    final rows = await _db.db.query(
      AppDatabase.transactionTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Transaction.fromMap(rows.first);
  }

  @override
  Future<void> add(Transaction transaction) async {
    await _db.db.insert(
      AppDatabase.transactionTable,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(Transaction transaction) async {
    await _db.db.update(
      AppDatabase.transactionTable,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  @override
  Future<void> delete(String id) async {
    await _db.db.delete(
      AppDatabase.transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}