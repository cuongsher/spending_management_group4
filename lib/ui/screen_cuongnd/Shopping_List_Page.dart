import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/provider_cuongnd/shopping_list_provider.dart';

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
              child: Consumer(
                builder: (context, ref, child) {

                  final items = ref.watch(shoppingListProvider);

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {

                      final item = items[index];

                      return ListTile(
                        leading: const Icon(Icons.shopping_bag, color: Colors.blue),

                        title: Text(
                          item.itemName,
                          style: const TextStyle(fontSize: 16),
                        ),

                        subtitle: Text(
                          "Price: ${item.estimatedPrice}",
                        ),

                        trailing: Text(item.status),
                      );
                    },
                  );
                },
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