import 'package:flutter/material.dart';
import 'package:spending_management_group4/data/database/models/ShoppingItem.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6DBE9A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6DBE9A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Danh Sách Mua Sắm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications_none),
          )
        ],
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

            const SizedBox(height: 10),

            /// Danh sách
            Expanded(
              child: ListView(
                children: const [

                  ShoppingItem(
                    title: "Kem Đánh răng",
                    time: "18:46 - 15/10",
                    icon: Icons.shopping_bag,
                  ),

                  ShoppingItem(
                    title: "Dầu gội đầu",
                    time: "18:46 - 15/10",
                    icon: Icons.spa,
                  ),

                  ShoppingItem(
                    title: "Bàn chải đánh răng",
                    time: "18:46 - 15/10",
                    icon: Icons.home_repair_service,
                  ),

                  ShoppingItem(
                    title: "Túi thơm cho xe ôtô",
                    time: "18:46 - 15/10",
                    icon: Icons.directions_car,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// Nút thêm sản phẩm
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6DBE9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text("Thêm Sản Phẩm"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}