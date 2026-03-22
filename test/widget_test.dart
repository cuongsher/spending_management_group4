import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
import 'package:spending_management_group4/main.dart';
import 'package:spending_management_group4/router/app_router.dart';
import 'package:spending_management_group4/ui/provider/auth_provider.dart';
import 'package:spending_management_group4/ui/provider/customize_provider.dart';
import 'package:spending_management_group4/ui/provider/history_provider.dart';
import 'package:spending_management_group4/ui/provider/profile_provider.dart';
import 'package:spending_management_group4/ui/provider/report_provider.dart';
import 'package:spending_management_group4/ui/provider/transaction_provider.dart';
import 'package:spending_management_group4/ui/screens/customize_screen.dart';
import 'package:spending_management_group4/ui/screens/history_screen.dart';
import 'package:spending_management_group4/ui/screens/profile_screen.dart';
import 'package:spending_management_group4/ui/screens/report_screen.dart';

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
}

Widget _buildRouteApp(String route) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(AuthRepository(AuthSource())),
      ),
      ChangeNotifierProvider(
        create: (_) =>
            CustomizeProvider(CustomizeRepository(CustomizeSource())),
      ),
      ChangeNotifierProvider(
        create: (_) => HistoryProvider(HistoryRepository(HistorySource())),
      ),
      ChangeNotifierProvider(
        create: (_) => ReportProvider(ReportRepository(ReportSource())),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileProvider(ProfileRepository(ProfileSource())),
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
