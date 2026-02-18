import 'package:flutter/material.dart';
import 'package:spending_management_group4/features/CustomPage.dart';
import 'package:spending_management_group4/features/homePage.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key,required this.title});
  final String title;
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    const MyHomePage(title: 'Home',), // 👈 Trang Home có scroll
    const Center(child: Text("Báo Cáo")),
    const Center(child: Text("Lịch Sử")),
    const CustomPage(),
    const Center(child: Text("Cá Nhân")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Báo Cáo'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Lịch Sử'),
          BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'Tùy Chỉnh'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá Nhân'),
        ],
      ),
    );
  }
}