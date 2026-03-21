import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spending_management_group4/ui/screen_cuongnd/HomeContent.dart';
import 'package:spending_management_group4/ui/screen_ngan/screen_add_transaction.dart';
import 'package:spending_management_group4/ui/widget_ngan/app_shell.dart';
import 'package:spending_management_group4/ui/widget_ngan/app_theme.dart';

// void main() {
//   runApp(
//     const ProviderScope(
//       child: AppShell(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.green.shade900,
//         ),
//       ),
//
//       home: const HomeContent(title: 'SHER HOME PAGE'),
//
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestDemo',
      theme: AppTheme.light(),
      home: const AppShell(),
      routes: {
        AddTransactionScreen.routeName: (_) => const AddTransactionScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

