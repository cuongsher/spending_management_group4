import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:spending_management_group4/data/database/models/BudgetModel.dart';
import 'package:spending_management_group4/data/database/models/TransactionModel.dart';
import 'package:spending_management_group4/data/database/models/UserModel.dart';
import 'package:spending_management_group4/data/repository/auth_repository.dart';
import 'package:spending_management_group4/data/repository/customize_repository.dart';
import 'package:spending_management_group4/data/repository/history_repository.dart';
import 'package:spending_management_group4/data/repository/home_repository.dart';
import 'package:spending_management_group4/data/repository/profile_repository.dart';
import 'package:spending_management_group4/data/repository/report_repository.dart';
import 'package:spending_management_group4/data/repository/transaction_repository.dart';
import 'package:spending_management_group4/data/sources/auth_source.dart';
import 'package:spending_management_group4/data/sources/customize_source.dart';
import 'package:spending_management_group4/data/sources/history_source.dart';
import 'package:spending_management_group4/data/sources/home_source.dart';
import 'package:spending_management_group4/data/sources/profile_source.dart';
import 'package:spending_management_group4/data/sources/report_source.dart';
import 'package:spending_management_group4/data/sources/transaction_source.dart';
import 'package:spending_management_group4/main.dart';
import 'package:spending_management_group4/router/app_router.dart';
import 'package:spending_management_group4/ui/provider/auth_provider.dart';
import 'package:spending_management_group4/ui/provider/customize_provider.dart';
import 'package:spending_management_group4/ui/provider/history_provider.dart';
import 'package:spending_management_group4/ui/provider/home_provider.dart';
import 'package:spending_management_group4/ui/provider/profile_provider.dart';
import 'package:spending_management_group4/ui/provider/report_provider.dart';
import 'package:spending_management_group4/ui/provider/transaction_provider.dart';
import 'package:spending_management_group4/ui/screens/customize_screen.dart';
import 'package:spending_management_group4/ui/screens/history_screen.dart';
import 'package:spending_management_group4/ui/screens/profile_screen.dart';
import 'package:spending_management_group4/ui/screens/report_screen.dart';
import 'package:spending_management_group4/ui/widgets/app_bottom_nav.dart';

void main() {
  testWidgets('launch screen is shown on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyLoopApp());

    expect(find.text('MoneyLoop'), findsOneWidget);
  });

  testWidgets('history screen route builds', (WidgetTester tester) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.history));
    await tester.pump();

    expect(find.byType(HistoryScreen), findsOneWidget);
  });

  testWidgets('report screen route builds', (WidgetTester tester) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.report));
    await tester.pump();

    expect(find.byType(ReportScreen), findsOneWidget);
  });

  testWidgets('customize screen route builds', (WidgetTester tester) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.customize));
    await tester.pump();

    expect(find.byType(CustomizeScreen), findsOneWidget);
  });

  testWidgets('profile screen route builds', (WidgetTester tester) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.profile));
    await tester.pump();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });

  testWidgets('home content scrolls while footer stays fixed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.home));
    await tester.pumpAndSettle();

    final footerBefore = tester.getTopLeft(find.byType(AppBottomNav));
    expect(find.text('Hạn Mức Chi Tiêu'), findsOneWidget);

    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    final footerAfter = tester.getTopLeft(find.byType(AppBottomNav));
    expect(footerAfter.dy, footerBefore.dy);
    expect(find.text('Hạn Mức Chi Tiêu'), findsOneWidget);
  });

  testWidgets('report content scrolls while footer stays fixed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.report));
    await tester.pumpAndSettle();

    final footerBefore = tester.getTopLeft(find.byType(AppBottomNav));

    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -220));
    await tester.pumpAndSettle();

    final footerAfter = tester.getTopLeft(find.byType(AppBottomNav));
    expect(footerAfter.dy, footerBefore.dy);
    expect(find.text('Thu Nhập & Chi Tiêu'), findsOneWidget);
  });

  testWidgets('history content scrolls while footer stays fixed', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildRouteApp(AppRouter.history));
    await tester.pumpAndSettle();

    final footerBefore = tester.getTopLeft(find.byType(AppBottomNav));
    expect(find.text('Tháng 3'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -260));
    await tester.pumpAndSettle();

    final footerAfter = tester.getTopLeft(find.byType(AppBottomNav));
    expect(footerAfter.dy, footerBefore.dy);
    expect(find.text('Tháng 3'), findsNothing);
  });
}

Widget _buildRouteApp(String route) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(AuthRepository(AuthSource())),
      ),
      ChangeNotifierProvider(
        create: (_) => HomeProvider(_FakeHomeRepository()),
      ),
      ChangeNotifierProvider(
        create: (_) =>
            CustomizeProvider(CustomizeRepository(CustomizeSource())),
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

class _FakeHomeRepository extends HomeRepository {
  _FakeHomeRepository() : super(HomeSource());

  @override
  Future<HomeDashboardData> loadDashboard() async {
    return HomeDashboardData(
      user: UserModel(
        id: 1,
        fullName: 'Nguyễn Hoàng',
        email: 'demo@moneyloop.app',
        phone: '0987654321',
        birthDate: '20/10/2004',
        password: '123456',
        createdAt: '2026-03-21T00:00:00.000',
      ),
      totalIncome: 5200,
      totalExpense: 1187.4,
      balance: 4012.6,
      historyItems: List.generate(
        6,
        (index) => HomeHistoryItem(
          title: 'Mục $index',
          subtitle: '2026-03-${20 - index}',
          periodLabel: 'Chi tiêu',
          amount: 100 + index.toDouble(),
          isExpense: true,
        ),
      ),
      budgets: List.generate(
        5,
        (index) => BudgetModel(
          id: index + 1,
          userId: 1,
          categoryId: index + 1,
          budgetName: 'Ngân sách $index',
          amount: 1000 + (index * 100),
          startDate: '01/04',
          endDate: '30/04',
          repeatType: 'monthly',
        ),
      ),
      breakdown: [
        CategoryBreakdownItem(name: 'Thuê Nhà', amount: 674.4, percentage: 57),
        CategoryBreakdownItem(name: 'Mua Sắm', amount: 250, percentage: 21),
        CategoryBreakdownItem(name: 'Giải Trí', amount: 163, percentage: 14),
        CategoryBreakdownItem(name: 'Ăn Uống', amount: 100, percentage: 8),
      ],
      notifications: const [],
    );
  }
}

class _FakeHistoryRepository extends HistoryRepository {
  _FakeHistoryRepository() : super(HistorySource());

  @override
  Future<HistoryDashboardData> loadHistory({String filter = 'all'}) async {
    final items = List.generate(
      10,
      (index) => HistoryTransactionItem(
        transaction: TransactionModel(
          id: index + 1,
          userId: 1,
          categoryId: 2,
          type: 'expense',
          amount: 100 + index.toDouble(),
          date: '2026-03-${(20 - index).toString().padLeft(2, '0')}',
          address: 'Address $index',
          note: 'Note $index',
        ),
        title: 'Giao dịch $index',
        subtitle: '20/03/2026',
        scheduleLabel: 'Thường xuyên',
        amount: 100 + index.toDouble(),
        isExpense: true,
        rawDate: DateTime(2026, 3, 20 - index),
      ),
    );

    return HistoryDashboardData(
      balance: 4012.6,
      totalIncome: 5200,
      totalExpense: 1187.4,
      sections: [
        HistoryMonthSection(title: 'Tháng 3', items: items),
      ],
    );
  }
}

class _FakeReportRepository extends ReportRepository {
  _FakeReportRepository() : super(ReportSource());

  @override
  Future<ReportDashboardData> loadReport({String period = 'month'}) async {
    return ReportDashboardData(
      totalIncome: 5200,
      totalExpense: 1187.4,
      progress: 0.3,
      bars: [
        ReportBarItem(label: 'T2', income: 1000, expense: 200),
        ReportBarItem(label: 'T3', income: 800, expense: 300),
        ReportBarItem(label: 'T4', income: 1200, expense: 250),
        ReportBarItem(label: 'T5', income: 700, expense: 150),
        ReportBarItem(label: 'T6', income: 1500, expense: 287.4),
      ],
      breakdown: [
        ReportPieItem(name: 'Thuê Nhà', amount: 674.4, percentage: 57),
        ReportPieItem(name: 'Mua Sắm', amount: 250, percentage: 21),
        ReportPieItem(name: 'Giải Trí', amount: 163, percentage: 14),
        ReportPieItem(name: 'Ăn Uống', amount: 100, percentage: 8),
      ],
    );
  }
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
