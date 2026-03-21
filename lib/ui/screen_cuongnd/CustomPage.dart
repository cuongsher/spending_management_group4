import 'package:flutter/material.dart';


import 'CategoryPage.dart';
import 'Shopping_List_Page.dart';

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
          childAspectRatio: 0.75, // ⭐ quan trọng để tránh overflow

          children: [

            buildItem(
              context,
              Icons.menu,
              "Hạn Mục\nThu /Chi",
              const CategoryPage(),
            ),

            buildItem(
              context,
              Icons.credit_card,
              "Hạn Mức Chi",
              const Scaffold(
                body: Center(child: Text("Hạn mức chi")),
              ),
            ),

            buildItem(
              context,
              Icons.work_outline,
              "Khoản Thu/Chi\nĐịnh Kỳ",
              const Scaffold(
                body: Center(child: Text("Khoản định kỳ")),
              ),
            ),

            buildItem(
              context,
              Icons.description,
              "Quản Lý\nTài Sản",
              const Scaffold(
                body: Center(child: Text("Quản lý tài sản")),
              ),
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.blue.shade300,
              borderRadius: BorderRadius.circular(25),
            ),

            child: Icon(
              icon,
              size: 36,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}