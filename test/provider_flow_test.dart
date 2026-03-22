import 'package:flutter_test/flutter_test.dart';
import 'package:spending_management_group4/data/database/models/AssetModel.dart';
import 'package:spending_management_group4/data/database/models/BudgetModel.dart';
import 'package:spending_management_group4/data/database/models/CategoryModel.dart';
import 'package:spending_management_group4/data/database/models/RecurringTransactionModel.dart';
import 'package:spending_management_group4/data/database/models/ShoppingListModel.dart';
import 'package:spending_management_group4/data/database/models/TransactionModel.dart';
import 'package:spending_management_group4/data/database/models/UserModel.dart';
import 'package:spending_management_group4/data/repository/auth_repository.dart';
import 'package:spending_management_group4/data/repository/budget_repository.dart';
import 'package:spending_management_group4/data/repository/customize_repository.dart';
import 'package:spending_management_group4/data/repository/profile_repository.dart';
import 'package:spending_management_group4/data/repository/transaction_repository.dart';
import 'package:spending_management_group4/data/sources/auth_source.dart';
import 'package:spending_management_group4/data/sources/budget_source.dart';
import 'package:spending_management_group4/data/sources/customize_source.dart';
import 'package:spending_management_group4/data/sources/profile_source.dart';
import 'package:spending_management_group4/data/sources/transaction_source.dart';
import 'package:spending_management_group4/ui/provider/auth_provider.dart';
import 'package:spending_management_group4/ui/provider/budget_provider.dart';
import 'package:spending_management_group4/ui/provider/customize_provider.dart';
import 'package:spending_management_group4/ui/provider/profile_provider.dart';
import 'package:spending_management_group4/ui/provider/transaction_provider.dart';

void main() {
  group('AuthProvider validation and flow', () {
    test('login success sets current user', () async {
      final provider = AuthProvider(
        FakeAuthRepository(loginUser: _demoUser(id: 7)),
      );

      final success = await provider.login('demo@moneyloop.app', '123456');

      expect(success, isTrue);
      expect(provider.currentUser?.id, 7);
      expect(provider.currentUserId, 7);
      expect(provider.isLoading, isFalse);
    });

    test('register rejects empty fields', () async {
      final provider = AuthProvider(FakeAuthRepository());

      final success = await provider.register(
        fullName: '',
        email: '',
        phone: '',
        birthDate: '',
        password: '',
        confirmPassword: '',
      );

      expect(success, isFalse);
      expect(provider.errorMessage, isNotNull);
    });

    test('register rejects mismatched passwords', () async {
      final provider = AuthProvider(FakeAuthRepository());

      final success = await provider.register(
        fullName: 'Nguyen',
        email: 'a@a.com',
        phone: '0123',
        birthDate: '01/01/2000',
        password: '123',
        confirmPassword: '456',
      );

      expect(success, isFalse);
      expect(provider.errorMessage, isNotNull);
    });

    test('forgot password then reset password succeeds', () async {
      final provider = AuthProvider(
        FakeAuthRepository(emailExists: true, resetPasswordSuccess: true),
      );

      final forgotSuccess = await provider.forgotPassword('demo@moneyloop.app');
      final resetSuccess = await provider.resetPassword('newpass', 'newpass');

      expect(forgotSuccess, isTrue);
      expect(resetSuccess, isTrue);
    });

    test('reset password fails when session missing', () async {
      final provider = AuthProvider(FakeAuthRepository());

      final success = await provider.resetPassword('newpass', 'newpass');

      expect(success, isFalse);
      expect(provider.errorMessage, isNotNull);
    });
  });

  group('BudgetProvider flow', () {
    test('loadBudgets populates items', () async {
      final provider = BudgetProvider(
        FakeBudgetRepository(
          seedBudgets: [
            BudgetModel(
              id: 1,
              userId: 1,
              categoryId: 3,
              budgetName: 'Ăn Uống',
              amount: 100,
              startDate: '01/04',
              endDate: '30/04',
              repeatType: 'monthly',
            ),
          ],
        ),
      );

      await provider.loadBudgets();

      expect(provider.budgets, hasLength(1));
      expect(provider.isLoading, isFalse);
    });

    test('addBudget adds then reloads list', () async {
      final repo = FakeBudgetRepository(seedBudgets: []);
      final provider = BudgetProvider(repo);

      final success = await provider.addBudget(
        BudgetModel(
          userId: 1,
          categoryId: 4,
          budgetName: 'Mua Sắm',
          amount: 200,
          startDate: '01/04',
          endDate: '30/04',
          repeatType: 'monthly',
        ),
      );

      expect(success, isTrue);
      expect(provider.budgets, hasLength(1));
      expect(provider.budgets.first.budgetName, 'Mua Sắm');
    });
  });

  group('CustomizeProvider flow', () {
    test('load dashboard/categories/assets/shopping/recurring works', () async {
      final provider = CustomizeProvider(FakeCustomizeRepository());

      await provider.loadDashboard();
      await provider.loadCategories(type: 'income');
      await provider.loadAssets();
      await provider.loadShoppingItems();
      await provider.loadRecurringItems(type: 'income');

      expect(provider.dashboard, isNotNull);
      expect(provider.selectedCategoryType, 'income');
      expect(provider.categories, isNotEmpty);
      expect(provider.assets, isNotEmpty);
      expect(provider.shoppingItems, isNotEmpty);
      expect(provider.recurringItems, isNotEmpty);
    });

    test('addRecurringTransaction reloads items', () async {
      final provider = CustomizeProvider(FakeCustomizeRepository());

      final success = await provider.addRecurringTransaction(
        RecurringTransactionModel(
          userId: 1,
          categoryId: 3,
          amount: 500,
          startDate: '01/10/2024',
          repeatCycle: 'Hàng Tháng',
          note: 'Ăn đêm',
        ),
      );

      expect(success, isTrue);
      expect(provider.recurringItems, isNotEmpty);
    });

    test('save and delete category works', () async {
      final provider = CustomizeProvider(FakeCustomizeRepository());
      await provider.loadCategories(type: 'expense');

      final saved = await provider.saveCategory(
        CategoryModel(
          userId: 1,
          name: 'Đi Lại',
          type: 'expense',
          description: 'Chi phí di chuyển',
        ),
      );

      expect(saved, isTrue);
      expect(provider.categories.any((item) => item.name == 'Đi Lại'), isTrue);

      final created = provider.categories.firstWhere((item) => item.name == 'Đi Lại');
      final deleted = await provider.deleteCategory(created.id!);

      expect(deleted, isTrue);
      expect(provider.categories.any((item) => item.name == 'Đi Lại'), isFalse);
    });

    test('save and delete shopping item works', () async {
      final provider = CustomizeProvider(FakeCustomizeRepository());
      await provider.loadShoppingItems();

      final saved = await provider.saveShoppingItem(
        ShoppingListModel(
          userId: 1,
          itemName: 'Sữa',
          estimatedPrice: 25,
          status: 'active',
        ),
      );

      expect(saved, isTrue);
      expect(
        provider.shoppingItems.any((item) => item.itemName == 'Sữa'),
        isTrue,
      );

      final created = provider.shoppingItems.firstWhere(
        (item) => item.itemName == 'Sữa',
      );
      final deleted = await provider.deleteShoppingItem(created.id!);

      expect(deleted, isTrue);
      expect(
        provider.shoppingItems.any((item) => item.itemName == 'Sữa'),
        isFalse,
      );
    });
  });

  group('ProfileProvider flow', () {
    test('load profile falls back to primary user', () async {
      final provider = ProfileProvider(FakeProfileRepository());

      await provider.loadProfile();

      expect(provider.user, isNotNull);
      expect(provider.user?.fullName, 'Nguyễn Hoàng');
    });

    test('update profile refreshes user data', () async {
      final repo = FakeProfileRepository();
      final provider = ProfileProvider(repo);

      final success = await provider.updateProfile(
        userId: 1,
        fullName: 'Nguyen Moi',
        phone: '0999',
        email: 'new@mail.com',
      );

      expect(success, isTrue);
      expect(provider.user?.fullName, 'Nguyen Moi');
      expect(provider.user?.email, 'new@mail.com');
    });

    test('update password rejects mismatched confirm password', () async {
      final provider = ProfileProvider(FakeProfileRepository());

      final success = await provider.updatePassword(
        userId: 1,
        currentPassword: '123456',
        newPassword: '111',
        confirmPassword: '222',
      );

      expect(success, isFalse);
      expect(provider.errorMessage, isNotNull);
    });

    test('delete account failure keeps user intact', () async {
      final repo = FakeProfileRepository(deleteSuccess: false);
      final provider = ProfileProvider(repo);
      await provider.loadProfile();

      final success = await provider.deleteAccount(userId: 1, password: 'sai');

      expect(success, isFalse);
      expect(provider.user, isNotNull);
    });
  });

  group('TransactionProvider flow', () {
    test('load categories and add transaction works', () async {
      final provider = TransactionProvider(FakeTransactionRepository());

      await provider.loadCategories(type: 'expense');
      expect(provider.categories, isNotEmpty);

      final success = await provider.addTransaction(
        TransactionModel(
          userId: 1,
          categoryId: provider.categories.first.id!,
          type: 'expense',
          amount: 120,
          date: '2026-03-22',
          address: 'Test address',
          note: 'Test note',
        ),
      );

      expect(success, isTrue);
      expect(provider.isLoading, isFalse);
    });

    test('update and delete transaction works', () async {
      final repo = FakeTransactionRepository();
      final provider = TransactionProvider(repo);

      final created = TransactionModel(
        id: 1,
        userId: 1,
        categoryId: 2,
        type: 'expense',
        amount: 120,
        date: '2026-03-22',
        address: 'Old',
        note: 'Old note',
      );

      await provider.addTransaction(created);

      final updated = await provider.updateTransaction(
        TransactionModel(
          id: 1,
          userId: 1,
          categoryId: 2,
          type: 'expense',
          amount: 250,
          date: '2026-03-22',
          address: 'New',
          note: 'New note',
        ),
      );

      expect(updated, isTrue);
      expect(repo.transactions.single.amount, 250);
      expect(repo.transactions.single.address, 'New');

      final deleted = await provider.deleteTransaction(1);

      expect(deleted, isTrue);
      expect(repo.transactions, isEmpty);
    });
  });
}

class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository({
    this.loginUser,
    this.registerSuccess = true,
    this.emailExists = false,
    this.resetPasswordSuccess = true,
    this.fakeCurrentUserId,
  }) : super(AuthSource());

  UserModel? loginUser;
  bool registerSuccess;
  bool emailExists;
  bool resetPasswordSuccess;
  int? fakeCurrentUserId;

  @override
  Future<UserModel?> login(String email, String password) async => loginUser;

  @override
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String birthDate,
    required String password,
  }) async => registerSuccess;

  @override
  Future<bool> checkEmailExists(String email) async => emailExists;

  @override
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async => resetPasswordSuccess;

  @override
  int? get currentUserId => fakeCurrentUserId ?? loginUser?.id;

  @override
  void logout() {
    loginUser = null;
    fakeCurrentUserId = null;
  }
}

class FakeBudgetRepository extends BudgetRepository {
  FakeBudgetRepository({required this.seedBudgets}) : super(BudgetSource());

  final List<BudgetModel> seedBudgets;

  @override
  Future<List<BudgetModel>> getBudgets() async =>
      List<BudgetModel>.from(seedBudgets);

  @override
  Future<void> addBudget(BudgetModel budget) async {
    seedBudgets.add(budget);
  }

  @override
  Future<Map<int, double>> getSpentByCategory() async => {
    for (final budget in seedBudgets) budget.categoryId: budget.amount * 0.25,
  };
}

class FakeCustomizeRepository extends CustomizeRepository {
  FakeCustomizeRepository() : super(CustomizeSource());

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: 1,
      userId: 1,
      name: 'Lương',
      type: 'income',
      description: 'Demo',
    ),
    CategoryModel(
      id: 2,
      userId: 1,
      name: 'Ăn Uống',
      type: 'expense',
      description: 'Demo',
    ),
  ];
  final List<ShoppingListModel> _shoppingItems = [
    ShoppingListModel(
      id: 1,
      userId: 1,
      itemName: 'Kem Đánh Răng',
      estimatedPrice: 18,
      status: 'active',
    ),
  ];
  final List<AssetModel> _assets = [
    AssetModel(
      id: 1,
      userId: 1,
      assetName: 'Vàng Bạc',
      amount: 3700,
      description: 'Tài sản tài chính',
    ),
  ];
  final List<RecurringItem> _items = [
    RecurringItem(
      id: 1,
      userId: 1,
      categoryId: 1,
      title: 'Lương',
      amount: 4000,
      startDate: '01/10/2024',
      repeatCycle: 'Hàng Tháng',
      type: 'income',
    ),
  ];

  @override
  Future<CustomizeDashboardData> loadDashboard() async {
    return CustomizeDashboardData(
      totalBalance: 6700,
      totalExpense: 1200,
      spendingProgress: 0.18,
    );
  }

  @override
  Future<List<CategoryModel>> getCategories({required String type}) async {
    return _categories.where((item) => item.type == type).toList();
  }

  @override
  Future<void> addCategory(CategoryModel model) async {
    _categories.add(
      CategoryModel(
        id: _categories.length + 1,
        userId: model.userId,
        name: model.name,
        type: model.type,
        description: model.description,
      ),
    );
  }

  @override
  Future<void> updateCategory(CategoryModel model) async {
    final index = _categories.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      _categories[index] = model;
    }
  }

  @override
  Future<void> deleteCategory(int id) async {
    _categories.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<ShoppingListModel>> getShoppingItems() async {
    return List<ShoppingListModel>.from(_shoppingItems);
  }

  @override
  Future<void> addShoppingItem(ShoppingListModel model) async {
    _shoppingItems.add(
      ShoppingListModel(
        id: _shoppingItems.length + 1,
        userId: model.userId,
        itemName: model.itemName,
        estimatedPrice: model.estimatedPrice,
        status: model.status,
      ),
    );
  }

  @override
  Future<void> updateShoppingItem(ShoppingListModel model) async {
    final index = _shoppingItems.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      _shoppingItems[index] = model;
    }
  }

  @override
  Future<void> deleteShoppingItem(int id) async {
    _shoppingItems.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<AssetModel>> getAssets() async {
    return List<AssetModel>.from(_assets);
  }

  @override
  Future<void> addAsset(AssetModel model) async {
    _assets.add(
      AssetModel(
        id: _assets.length + 1,
        userId: model.userId,
        assetName: model.assetName,
        amount: model.amount,
        description: model.description,
      ),
    );
  }

  @override
  Future<void> updateAsset(AssetModel model) async {
    final index = _assets.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      _assets[index] = model;
    }
  }

  @override
  Future<void> deleteAsset(int id) async {
    _assets.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<RecurringItem>> getRecurringTransactions({
    required String type,
  }) async {
    return _items.where((item) => item.type == type).toList();
  }

  @override
  Future<void> addRecurringTransaction(RecurringTransactionModel model) async {
    _items.add(
      RecurringItem(
        id: _items.length + 1,
        userId: model.userId,
        categoryId: model.categoryId,
        title: model.note,
        amount: model.amount,
        startDate: model.startDate,
        repeatCycle: model.repeatCycle,
        type: model.categoryId == 1 ? 'income' : 'expense',
      ),
    );
  }

  @override
  Future<void> updateRecurringTransaction(RecurringTransactionModel model) async {
    final index = _items.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      _items[index] = RecurringItem(
        id: model.id!,
        userId: model.userId,
        categoryId: model.categoryId,
        title: model.note,
        amount: model.amount,
        startDate: model.startDate,
        repeatCycle: model.repeatCycle,
        type: model.categoryId == 1 ? 'income' : 'expense',
      );
    }
  }

  @override
  Future<void> deleteRecurringTransaction(int id) async {
    _items.removeWhere((item) => item.id == id);
  }
}

class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository({
    this.passwordUpdateSuccess = true,
    this.deleteSuccess = true,
  }) : super(ProfileSource());

  bool passwordUpdateSuccess;
  bool deleteSuccess;
  UserModel _user = _demoUser(id: 1);

  @override
  Future<UserModel?> getPrimaryUser() async => _user;

  @override
  Future<UserModel?> getUserById(int userId) async =>
      _user.id == userId ? _user : null;

  @override
  Future<bool> updateProfile({
    required int userId,
    required String fullName,
    required String phone,
    required String email,
  }) async {
    _user = UserModel(
      id: userId,
      fullName: fullName,
      email: email,
      phone: phone,
      birthDate: _user.birthDate,
      password: _user.password,
      createdAt: _user.createdAt,
    );
    return true;
  }

  @override
  Future<bool> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async => passwordUpdateSuccess;

  @override
  Future<bool> deleteAccount({
    required int userId,
    required String password,
  }) async => deleteSuccess;
}

class FakeTransactionRepository extends TransactionRepository {
  FakeTransactionRepository() : super(TransactionSource());

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: 1,
      userId: 1,
      name: 'Lương',
      type: 'income',
      description: 'Thu nhập',
    ),
    CategoryModel(
      id: 2,
      userId: 1,
      name: 'Ăn Uống',
      type: 'expense',
      description: 'Chi ăn uống',
    ),
  ];
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  @override
  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    return _categories.where((item) => item.type == type).toList();
  }

  @override
  Future<void> addTransaction(TransactionModel model) async {
    _transactions.add(model);
  }

  @override
  Future<void> updateTransaction(TransactionModel model) async {
    final index = _transactions.indexWhere((item) => item.id == model.id);
    if (index >= 0) {
      _transactions[index] = model;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    _transactions.removeWhere((item) => item.id == id);
  }
}

UserModel _demoUser({required int id}) {
  return UserModel(
    id: id,
    fullName: 'Nguyễn Hoàng',
    email: 'demo@moneyloop.app',
    phone: '0987654321',
    birthDate: '20/10/2004',
    password: '123456',
    createdAt: '2026-03-21T00:00:00.000',
  );
}
