import 'package:flutter/material.dart';
import 'app/app_shell.dart';
import 'app/app_theme.dart';
import 'features/transactions/presentation/add_transaction/add_transaction_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: AppTheme.light(),

      // ❗ BẮT BUỘC
      home: const AppShell(),

      // routes chỉ để điều hướng sau
      routes: {
        AddTransactionScreen.routeName: (_) =>
            const AddTransactionScreen(),
      },
    );
  }
}