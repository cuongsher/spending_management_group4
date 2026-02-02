import 'package:flutter/material.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            // Tổng quan
            Container(
              height: 150,
              color: Colors.pink,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topLeft,
              child: const Text('Tổng quan'),
            ),

            const SizedBox(height: 16),
            // Tình hình thu chi
            Container(
              height: 150,
              color: Colors.red,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topLeft,
              child: const Text('Tình hình thu chi'),
            ),

            const SizedBox(height: 16),
            // Tổng quan lịch sử
            Container(
              height: 150,
              color: Colors.blue,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topLeft,
              child: const Text('Tổng quan lịch sử'),
            ),

            const SizedBox(height: 16),
            // Hạn mức chi tiêu
            Container(
              height: 150,
              color: Colors.yellow,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topLeft,
              child: const Text('Hạn mức chi tiêu'),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // Thanh điều hướng
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Báo cáo'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}
