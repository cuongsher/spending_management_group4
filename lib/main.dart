import 'package:flutter/material.dart';
import 'package:spending_management_group4/features/HomeContent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Cho phép gọi toggleTheme từ page khác
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool darkMode = false;

  void toggleTheme(bool value) {
    setState(() {
      darkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: darkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade900,
          brightness: darkMode ? Brightness.dark : Brightness.light,
        ),
      ),

      home: const HomeContent(title: 'SHER HOME PAGE'),
    );
  }
}
