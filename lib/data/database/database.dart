import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'; // Đã thêm

class AppDatabase {
  AppDatabase._(this._db);
  final Database _db;

  static const _dbName = 'app.db';
  static const transactionTable = 'transactions';

  static Future<AppDatabase> open() async {
    // Hàm này yêu cầu thư viện path_provider
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $transactionTable (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            amount INTEGER NOT NULL,
            date TEXT NOT NULL,
            note TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
        await db.execute('CREATE INDEX idx_date ON $transactionTable(date)');
        await db.execute('CREATE INDEX idx_type ON $transactionTable(type)');
      },
    );

    return AppDatabase._(db);
  }

  Database get db => _db;

  static Future<void> deleteDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    await deleteDatabase(path);
  }
}