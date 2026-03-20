import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'router/app_router.dart';
import 'data/repository/auth_repository.dart';
import 'data/repository/budget_repository.dart';
import 'data/sources/auth_source.dart';
import 'data/sources/budget_source.dart';
import 'ui/provider/auth_provider.dart';
import 'ui/provider/budget_provider.dart';

void main() {
  runApp(const MoneyLoopApp());
}

class MoneyLoopApp extends StatelessWidget {
  const MoneyLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            AuthRepository(
              AuthSource(),
            ),
          ),
        ),
        ChangeNotifierProvider<BudgetProvider>(
          create: (_) => BudgetProvider(
            BudgetRepository(
              BudgetSource(),
            ),
          ),
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