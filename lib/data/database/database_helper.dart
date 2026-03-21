import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_manager.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedDemoData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _seedDemoData(db);
        }
      },
    );

    await _seedDemoData(_database!);
    await _normalizeDemoData(_database!);
    return _database!;
  }

  Future<void> _createTables(Database db) async {
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
  }

  Future<void> _seedDemoData(Database db) async {
    final userCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM User')) ??
        0;
    if (userCount == 0) {
      await db.insert('User', {
        'id': 1,
        'full_name': 'Nguyen Hoang',
        'email': 'demo@moneyloop.app',
        'phone': '0987654321',
        'birth_date': '20/10/2004',
        'password': '123456',
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    final categoryCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Category'),
        ) ??
        0;
    if (categoryCount == 0) {
      final batch = db.batch();
      final categories = [
        {'id': 1, 'name': 'Luong', 'type': 'income', 'description': 'Thu nhap'},
        {'id': 2, 'name': 'Thuong', 'type': 'income', 'description': 'Thuong'},
        {
          'id': 3,
          'name': 'An Uong',
          'type': 'expense',
          'description': 'Chi an uong',
        },
        {
          'id': 4,
          'name': 'Mua Sam',
          'type': 'expense',
          'description': 'Chi mua sam',
        },
        {
          'id': 5,
          'name': 'Thue Nha',
          'type': 'expense',
          'description': 'Chi nha o',
        },
        {
          'id': 6,
          'name': 'Giai Tri',
          'type': 'expense',
          'description': 'Chi giai tri',
        },
      ];
      for (final category in categories) {
        batch.insert('Category', {
          'id': category['id'],
          'user_id': 1,
          'name': category['name'],
          'type': category['type'],
          'description': category['description'],
        });
      }
      await batch.commit(noResult: true);
    }

    final transactionCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM TransactionTable'),
        ) ??
        0;
    if (transactionCount == 0) {
      final batch = db.batch();
      final transactions = [
        {
          'user_id': 1,
          'category_id': 1,
          'type': 'income',
          'amount': 4000.0,
          'date': '2026-03-01',
          'address': 'Cong ty ABC',
          'note': 'Luong thang 3',
        },
        {
          'user_id': 1,
          'category_id': 2,
          'type': 'income',
          'amount': 1200.0,
          'date': '2026-03-10',
          'address': 'Du an Freelance',
          'note': 'Thuong hieu suat',
        },
        {
          'user_id': 1,
          'category_id': 3,
          'type': 'expense',
          'amount': 100.0,
          'date': '2026-03-12',
          'address': 'Quan an dem',
          'note': 'An dem',
        },
        {
          'user_id': 1,
          'category_id': 4,
          'type': 'expense',
          'amount': 250.0,
          'date': '2026-03-14',
          'address': 'Sieu thi',
          'note': 'Mua sam',
        },
        {
          'user_id': 1,
          'category_id': 5,
          'type': 'expense',
          'amount': 674.4,
          'date': '2026-03-18',
          'address': 'Can ho',
          'note': 'Tien thue nha',
        },
        {
          'user_id': 1,
          'category_id': 6,
          'type': 'expense',
          'amount': 163.0,
          'date': '2026-03-20',
          'address': 'Rap phim',
          'note': 'Giai tri',
        },
      ];
      for (final transaction in transactions) {
        batch.insert('TransactionTable', transaction);
      }
      await batch.commit(noResult: true);
    }

    final budgetCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Budget'),
        ) ??
        0;
    if (budgetCount == 0) {
      final batch = db.batch();
      final budgets = [
        {
          'user_id': 1,
          'category_id': 3,
          'budget_name': 'An Uong',
          'amount': 100.0,
          'start_date': '01/04',
          'end_date': '30/04',
          'repeat_type': 'monthly',
        },
        {
          'user_id': 1,
          'category_id': 4,
          'budget_name': 'Mua Sam',
          'amount': 100.0,
          'start_date': '01/04',
          'end_date': '30/04',
          'repeat_type': 'monthly',
        },
        {
          'user_id': 1,
          'category_id': 6,
          'budget_name': 'Hoc Tap',
          'amount': 100.0,
          'start_date': '01/04',
          'end_date': '30/04',
          'repeat_type': 'monthly',
        },
      ];
      for (final budget in budgets) {
        batch.insert('Budget', budget);
      }
      await batch.commit(noResult: true);
    }

    final notificationCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Notification'),
        ) ??
        0;
    if (notificationCount == 0) {
      final batch = db.batch();
      final notifications = [
        {
          'user_id': 1,
          'title': 'Nhac nho',
          'content': 'Mua gi thi ghi lai nhe tinh yeu oi!',
          'created_at': '17:00 - 24/04',
          'status': 'today',
        },
        {
          'user_id': 1,
          'title': 'Thong bao moi',
          'content': 'Cap nhat de su dung tien ich thu vi',
          'created_at': '17:00 - 24/04',
          'status': 'today',
        },
        {
          'user_id': 1,
          'title': 'Giao dich',
          'content': 'Hom qua ban da mua cai quan 100k!',
          'created_at': '17:00 - 24/04',
          'status': 'yesterday',
        },
        {
          'user_id': 1,
          'title': 'Bao cao',
          'content': 'Bao cao tuan qua mua sam qua lo',
          'created_at': '17:00 - 24/04',
          'status': 'this_week',
        },
      ];
      for (final item in notifications) {
        batch.insert('Notification', item);
      }
      await batch.commit(noResult: true);
    }

    final assetCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Asset'),
        ) ??
        0;
    if (assetCount == 0) {
      final batch = db.batch();
      final assets = [
        {
          'user_id': 1,
          'asset_name': 'Vang Bac',
          'amount': 3700.0,
          'description': 'Tai san tai chinh',
        },
        {
          'user_id': 1,
          'asset_name': 'Xe Co',
          'amount': 3000.0,
          'description': 'Tai san vat ly',
        },
      ];
      for (final item in assets) {
        batch.insert('Asset', item);
      }
      await batch.commit(noResult: true);
    }

    final shoppingCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM ShoppingList'),
        ) ??
        0;
    if (shoppingCount == 0) {
      final batch = db.batch();
      final shoppingItems = [
        {'item_name': 'Kem Danh Rang', 'estimated_price': 18.0},
        {'item_name': 'Dau Goi Dau', 'estimated_price': 42.0},
        {'item_name': 'Ban Chai Danh Rang', 'estimated_price': 12.0},
        {'item_name': 'Tui Thom Cho Xe O To', 'estimated_price': 35.0},
      ];
      for (final item in shoppingItems) {
        batch.insert('ShoppingList', {
          'user_id': 1,
          'item_name': item['item_name'],
          'estimated_price': item['estimated_price'],
          'status': 'active',
        });
      }
      await batch.commit(noResult: true);
    }

    final recurringCount =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM RecurringTransaction'),
        ) ??
        0;
    if (recurringCount == 0) {
      final batch = db.batch();
      final recurringItems = [
        {
          'user_id': 1,
          'category_id': 3,
          'amount': 87.32,
          'start_date': '15/10/2024',
          'repeat_cycle': 'Hang Thang',
          'note': 'An dem',
        },
        {
          'user_id': 1,
          'category_id': 1,
          'amount': 4000.0,
          'start_date': '01/10/2024',
          'repeat_cycle': 'Hang Thang',
          'note': 'Luong',
        },
      ];
      for (final item in recurringItems) {
        batch.insert('RecurringTransaction', item);
      }
      await batch.commit(noResult: true);
    }
  }

  Future<void> _normalizeDemoData(Database db) async {
    final batch = db.batch();

    batch.update(
      'User',
      {'full_name': 'Nguyễn Hoàng'},
      where: 'email = ?',
      whereArgs: ['demo@moneyloop.app'],
    );

    final categories = [
      {'id': 1, 'name': 'Lương', 'description': 'Thu nhập'},
      {'id': 2, 'name': 'Thưởng', 'description': 'Thưởng'},
      {'id': 3, 'name': 'Ăn Uống', 'description': 'Chi ăn uống'},
      {'id': 4, 'name': 'Mua Sắm', 'description': 'Chi mua sắm'},
      {'id': 5, 'name': 'Thuê Nhà', 'description': 'Chi nhà ở'},
      {'id': 6, 'name': 'Giải Trí', 'description': 'Chi giải trí'},
    ];

    for (final category in categories) {
      batch.update(
        'Category',
        {'name': category['name'], 'description': category['description']},
        where: 'id = ? AND user_id = ?',
        whereArgs: [category['id'], 1],
      );
    }

    final budgets = [
      {'category_id': 3, 'budget_name': 'Ăn Uống'},
      {'category_id': 4, 'budget_name': 'Mua Sắm'},
      {'category_id': 6, 'budget_name': 'Học Tập'},
    ];

    for (final budget in budgets) {
      batch.update(
        'Budget',
        {'budget_name': budget['budget_name']},
        where: 'category_id = ? AND user_id = ?',
        whereArgs: [budget['category_id'], 1],
      );
    }

    final notifications = [
      {
        'id': 1,
        'title': 'Nhắc nhở',
        'content': 'Mua gì thì ghi lại nhé tình yêu ơi!',
      },
      {
        'id': 2,
        'title': 'Thông báo mới',
        'content': 'Cập nhật để sử dụng tiện ích thú vị',
      },
      {
        'id': 3,
        'title': 'Giao dịch',
        'content': 'Hôm qua bạn đã mua cái quần 100k!',
      },
      {
        'id': 4,
        'title': 'Báo cáo',
        'content': 'Báo cáo tuần qua mua sắm quá lố',
      },
    ];

    for (final item in notifications) {
      batch.update(
        'Notification',
        {'title': item['title'], 'content': item['content']},
        where: 'id = ? AND user_id = ?',
        whereArgs: [item['id'], 1],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> resetDatabaseForTest() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expense_manager.db');
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    await deleteDatabase(path);
  }
}
