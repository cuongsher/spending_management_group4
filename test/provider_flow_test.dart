import 'package:flutter_test/flutter_test.dart';
import 'package:spending_management_group4/data/database/models/AssetModel.dart';
import 'package:spending_management_group4/data/database/models/BudgetModel.dart';
import 'package:spending_management_group4/data/database/models/CategoryModel.dart';
import 'package:spending_management_group4/data/database/models/RecurringTransactionModel.dart';
import 'package:spending_management_group4/data/database/models/ShoppingListModel.dart';
import 'package:spending_management_group4/data/database/models/UserModel.dart';
import 'package:spending_management_group4/data/repository/auth_repository.dart';
import 'package:spending_management_group4/data/repository/budget_repository.dart';
import 'package:spending_management_group4/data/repository/customize_repository.dart';
import 'package:spending_management_group4/data/repository/profile_repository.dart';
import 'package:spending_management_group4/data/sources/auth_source.dart';
import 'package:spending_management_group4/data/sources/budget_source.dart';
import 'package:spending_management_group4/data/sources/customize_source.dart';
import 'package:spending_management_group4/data/sources/profile_source.dart';
import 'package:spending_management_group4/ui/provider/auth_provider.dart';
import 'package:spending_management_group4/ui/provider/budget_provider.dart';
import 'package:spending_management_group4/ui/provider/customize_provider.dart';
import 'package:spending_management_group4/ui/provider/profile_provider.dart';

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
}

class FakeCustomizeRepository extends CustomizeRepository {
  FakeCustomizeRepository() : super(CustomizeSource());

  final List<RecurringItem> _items = [
    RecurringItem(
      id: 1,
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
    return [
      CategoryModel(
        id: 1,
        userId: 1,
        name: type == 'income' ? 'Lương' : 'Ăn Uống',
        type: type,
        description: 'Demo',
      ),
    ];
  }

  @override
  Future<List<ShoppingListModel>> getShoppingItems() async {
    return [
      ShoppingListModel(
        id: 1,
        userId: 1,
        itemName: 'Kem Đánh Răng',
        estimatedPrice: 18,
        status: 'active',
      ),
    ];
  }

  @override
  Future<List<AssetModel>> getAssets() async {
    return [
      AssetModel(
        id: 1,
        userId: 1,
        assetName: 'Vàng Bạc',
        amount: 3700,
        description: 'Tài sản tài chính',
      ),
    ];
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
        title: model.note,
        amount: model.amount,
        startDate: model.startDate,
        repeatCycle: model.repeatCycle,
        type: model.categoryId == 1 ? 'income' : 'expense',
      ),
    );
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
