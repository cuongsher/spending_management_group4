import 'package:flutter/material.dart';
import 'package:spending_management_group4/features/CategoryPage.dart';
import 'package:spending_management_group4/features/Shopping_List_Page.dart';

class CustomPage extends StatelessWidget {
  const CustomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6DBE9A),
      appBar: AppBar(
        title: const Text("Tùy Chỉnh"),
        backgroundColor: const Color(0xFF6DBE9A),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFDCE5DD),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            buildItem(
              context,
              Icons.menu,
              "Hạn Mục\nThu /Chi",
              const CategoryPage(), // 👈 trang mới
            ),
            buildItem(
              context,
              Icons.credit_card,
              "Hạn Mức Chi",
              const Scaffold(body: Center(child: Text("Hạn mức chi"))),
            ),
            buildItem(
              context,
              Icons.work_outline,
              "Khoản Thu/Chi\nĐịnh Kỳ",
              const Scaffold(body: Center(child: Text("Khoản định kỳ"))),
            ),
            buildItem(
              context,
              Icons.description,
              "Quản Lý Tài Sản",
              const Scaffold(body: Center(child: Text("Quản lý tài sản"))),
            ),
            buildItem(
              context,
              Icons.receipt_long,
              "Danh Sách\nMua Sắm",
              const ShoppingListPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
      BuildContext context,
      IconData icon,
      String title,
      Widget page,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, size: 40, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
