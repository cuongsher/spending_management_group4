import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spending_management_group4/lib/ui/provider/transaction_provider.dart';


import 'lib/data/database/database_helper.dart';
import 'lib/data/repository/auth_repository.dart';
import 'lib/data/repository/budget_repository.dart';
import 'lib/data/repository/customize_repository.dart';
import 'lib/data/repository/history_repository.dart';
import 'lib/data/repository/home_repository.dart';
import 'lib/data/repository/notification_repository.dart';
import 'lib/data/repository/profile_repository.dart';
import 'lib/data/repository/report_repository.dart';
import 'lib/data/repository/transaction_repository.dart';
import 'lib/data/sources/auth_source.dart';
import 'lib/data/sources/budget_source.dart';
import 'lib/data/sources/customize_source.dart';
import 'lib/data/sources/history_source.dart';
import 'lib/data/sources/home_source.dart';
import 'lib/data/sources/notification_source.dart';
import 'lib/data/sources/profile_source.dart';
import 'lib/data/sources/report_source.dart';
import 'lib/data/sources/transaction_source.dart';
import 'lib/router/app_router.dart';
import 'lib/ui/provider/auth_provider.dart';
import 'lib/ui/provider/budget_provider.dart';
import 'lib/ui/provider/customize_provider.dart';
import 'lib/ui/provider/history_provider.dart';
import 'lib/ui/provider/home_provider.dart';
import 'lib/ui/provider/notification_provider.dart';
import 'lib/ui/provider/profile_provider.dart';
import 'lib/ui/provider/report_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;

  runApp(const MoneyLoopApp());
}

class MoneyLoopApp extends StatelessWidget {
  const MoneyLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(AuthRepository(AuthSource())),
        ),
        ChangeNotifierProvider<BudgetProvider>(
          create: (_) => BudgetProvider(BudgetRepository(BudgetSource())),
        ),
        ChangeNotifierProvider<CustomizeProvider>(
          create: (_) =>
              CustomizeProvider(CustomizeRepository(CustomizeSource())),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(HomeRepository(HomeSource())),
        ),
        ChangeNotifierProvider<HistoryProvider>(
          create: (_) => HistoryProvider(HistoryRepository(HistorySource())),
        ),
        ChangeNotifierProvider<ReportProvider>(
          create: (_) => ReportProvider(ReportRepository(ReportSource())),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(
            NotificationRepository(NotificationSource()),
          ),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(ProfileRepository(ProfileSource())),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) => TransactionProvider(TransactionRepository(TransactionSource())),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MoneyLoop',
        initialRoute: AppRouter.launch,
        routes: AppRouter.routes,
      ),
    );
  }
}
