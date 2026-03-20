import 'package:flutter/material.dart';
import 'package:spending_management_group4/ui/screens/CustomPage.dart';
import 'package:spending_management_group4/ui/screens/homePage.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.title});

  final String title;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  int selectedIndex = 0;

  final List<Widget> pages = const [
    MyHomePage(title: 'Home'),
    Center(child: Text("Báo Cáo")),
    Center(child: Text("Lịch Sử")),
    CustomPage(),
    Center(child: Text("Cá Nhân")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

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