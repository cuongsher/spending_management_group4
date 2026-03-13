import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "expense_manager.db");

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        // USER
        await db.execute('''
        CREATE TABLE User(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          full_name TEXT,
          email TEXT,
          phone TEXT,
          birth_date TEXT,
          password TEXT,
          created_at TEXT
        )
        ''');

        // PASSWORD RESET
        await db.execute('''
        CREATE TABLE PasswordReset(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          otp_code TEXT,
          expired_at TEXT,
          status TEXT,
          created_at TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id)
        )
        ''');

        // CATEGORY
        await db.execute('''
        CREATE TABLE Category(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          name TEXT,
          type TEXT,
          description TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id)
        )
        ''');

        // TRANSACTION
        await db.execute('''
        CREATE TABLE TransactionTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          category_id INTEGER,
          type TEXT,
          amount REAL,
          date TEXT,
          address TEXT,
          note TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id),
          FOREIGN KEY(category_id) REFERENCES Category(id)
        )
        ''');

        // BUDGET
        await db.execute('''
        CREATE TABLE Budget(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          category_id INTEGER,
          budget_name TEXT,
          amount REAL,
          start_date TEXT,
          end_date TEXT,
          repeat_type TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id),
          FOREIGN KEY(category_id) REFERENCES Category(id)
        )
        ''');

        // RECURRING TRANSACTION
        await db.execute('''
        CREATE TABLE RecurringTransaction(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          category_id INTEGER,
          amount REAL,
          start_date TEXT,
          repeat_cycle TEXT,
          note TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id),
          FOREIGN KEY(category_id) REFERENCES Category(id)
        )
        ''');

        // NOTIFICATION
        await db.execute('''
        CREATE TABLE Notification(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          title TEXT,
          content TEXT,
          created_at TEXT,
          status TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id)
        )
        ''');

        // ASSET
        await db.execute('''
        CREATE TABLE Asset(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          asset_name TEXT,
          amount REAL,
          description TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id)
        )
        ''');

        // SHOPPING LIST
        await db.execute('''
        CREATE TABLE ShoppingList(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          item_name TEXT,
          estimated_price REAL,
          status TEXT,
          FOREIGN KEY(user_id) REFERENCES User(id)
        )
        ''');

      },
    );

    return _database!;
  }
}