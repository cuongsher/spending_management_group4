import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:spending_management_group4/data/database/models/UserModel.dart';
import 'package:spending_management_group4/data/repository/auth_repository.dart';
import 'package:spending_management_group4/data/repository/customize_repository.dart';
import 'package:spending_management_group4/data/repository/history_repository.dart';
import 'package:spending_management_group4/data/repository/profile_repository.dart';
import 'package:spending_management_group4/data/repository/report_repository.dart';
import 'package:spending_management_group4/data/repository/transaction_repository.dart';
import 'package:spending_management_group4/data/sources/auth_source.dart';
import 'package:spending_management_group4/data/sources/customize_source.dart';
import 'package:spending_management_group4/data/sources/history_source.dart';
import 'package:spending_management_group4/data/sources/profile_source.dart';
import 'package:spending_management_group4/data/sources/report_source.dart';
import 'package:spending_management_group4/data/sources/transaction_source.dart';
import 'package:spending_management_group4/router/app_router.dart';
import 'package:spending_management_group4/ui/provider/auth_provider.dart';
import 'package:spending_management_group4/ui/provider/customize_provider.dart';
import 'package:spending_management_group4/ui/provider/history_provider.dart';
import 'package:spending_management_group4/ui/provider/profile_provider.dart';
import 'package:spending_management_group4/ui/provider/report_provider.dart';
import 'package:spending_management_group4/ui/provider/transaction_provider.dart';
import 'package:spending_management_group4/ui/screens/forgot_password_screen.dart';
import 'package:spending_management_group4/ui/screens/login_screen.dart';
import 'package:spending_management_group4/ui/screens/new_password_screen.dart';
import 'package:spending_management_group4/ui/screens/profile_screen.dart';
import 'package:spending_management_group4/ui/widgets/auth_button.dart';

void main() {
  testWidgets('launch screen auto navigates to onboarding', (
    WidgetTester tester,
  ) async {
    await _setLargeSurface(tester);
    await tester.pumpWidget(_buildApp(AppRouter.launch));

    expect(find.text('MoneyLoop'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(PageView), findsOneWidget);
  });

  testWidgets('welcome auth screen login button navigates to login', (
    WidgetTester tester,
  ) async {
    await _setLargeSurface(tester);
    await tester.pumpWidget(_buildApp(AppRouter.authChoice));

    await tester.tap(find.byType(AuthButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('forgot password success navigates to new password', (
    WidgetTester tester,
  ) async {
    await _setLargeSurface(tester);
    await tester.pumpWidget(
      _buildApp(
        AppRouter.forgotPassword,
        authRepository: _FakeAuthRepository(emailExists: true),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'demo@moneyloop.app');
    await tester.tap(find.byType(AuthButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(NewPasswordScreen), findsOneWidget);
  });

  testWidgets('forgot password failure stays on same screen', (
    WidgetTester tester,
  ) async {
    await _setLargeSurface(tester);
    await tester.pumpWidget(
      _buildApp(
        AppRouter.forgotPassword,
        authRepository: _FakeAuthRepository(emailExists: false),
      ),
    );

    await tester.enterText(find.byType(TextField).first, 'missing@mail.com');
    await tester.tap(find.byType(AuthButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    expect(find.byType(NewPasswordScreen), findsNothing);
  });

  testWidgets('bottom nav from customize opens profile', (
    WidgetTester tester,
  ) async {
    await _setLargeSurface(tester);
    await tester.pumpWidget(_buildApp(AppRouter.customize));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cá Nhân'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}

Widget _buildApp(String route, {AuthRepository? authRepository}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(authRepository ?? _FakeAuthRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => CustomizeProvider(_FakeCustomizeRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => HistoryProvider(_FakeHistoryRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => ReportProvider(_FakeReportRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(_FakeProfileRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) => TransactionProvider(
          TransactionRepository(TransactionSource()),
        ),
      ),
    ],
    child: MaterialApp(initialRoute: route, routes: AppRouter.routes),
  );
}

Future<void> _setLargeSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(430, 1100));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

class _FakeAuthRepository extends AuthRepository {
  _FakeAuthRepository({this.emailExists = true}) : super(AuthSource());

  final bool emailExists;

  @override
  Future<UserModel?> login(String email, String password) async => null;

  @override
  Future<bool> checkEmailExists(String email) async => emailExists;

  @override
  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async => true;
}

class _FakeCustomizeRepository extends CustomizeRepository {
  _FakeCustomizeRepository() : super(CustomizeSource());

  @override
  Future<CustomizeDashboardData> loadDashboard() async {
    return CustomizeDashboardData(
      totalBalance: 6700,
      totalExpense: 1200,
      spendingProgress: 0.18,
    );
  }
}

class _FakeHistoryRepository extends HistoryRepository {
  _FakeHistoryRepository() : super(HistorySource());
}

class _FakeReportRepository extends ReportRepository {
  _FakeReportRepository() : super(ReportSource());
}

class _FakeProfileRepository extends ProfileRepository {
  _FakeProfileRepository() : super(ProfileSource());

  @override
  Future<UserModel?> getPrimaryUser() async {
    return UserModel(
      id: 1,
      fullName: 'Nguyễn Hoàng',
      email: 'demo@moneyloop.app',
      phone: '0987654321',
      birthDate: '20/10/2004',
      password: '123456',
      createdAt: '2026-03-21T00:00:00.000',
    );
  }
}
