import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database/database_helper.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/budget_repository.dart';
import 'data/repository/customize_repository.dart';
import 'data/repository/home_repository.dart';
import 'data/repository/history_repository.dart';
import 'data/repository/notification_repository.dart';
import 'data/repository/profile_repository.dart';
import 'data/repository/report_repository.dart';
import 'data/sources/auth_source.dart';
import 'data/sources/budget_source.dart';
import 'data/sources/customize_source.dart';
import 'data/sources/home_source.dart';
import 'data/sources/history_source.dart';
import 'data/sources/notification_source.dart';
import 'data/sources/profile_source.dart';
import 'data/sources/report_source.dart';
import 'router/app_router.dart';
import 'ui/provider/auth_provider.dart';
import 'ui/provider/budget_provider.dart';
import 'ui/provider/customize_provider.dart';
import 'ui/provider/home_provider.dart';
import 'ui/provider/history_provider.dart';
import 'ui/provider/notification_provider.dart';
import 'ui/provider/profile_provider.dart';
import 'ui/provider/report_provider.dart';

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
