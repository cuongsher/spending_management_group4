import 'package:flutter/material.dart';
import 'package:spending_management_group4/features/homePage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      home: const MyHomePage(title: 'SHER HOME PAGE'),
      debugShowCheckedModeBanner: false,
    );
  }
}


