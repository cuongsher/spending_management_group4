import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6DBE9A),
      appBar: AppBar(
        title: const Text("Hạng Mục Thu /Chi"),
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
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 2 nút Thu - Chi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Mục Thu"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Mục Chi"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Search
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Danh sách
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.fastfood),
                    title: Text("Ăn Uống"),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Giao Thông"),
                  ),
                  ListTile(
                    leading: Icon(Icons.movie),
                    title: Text("Giải Trí"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}