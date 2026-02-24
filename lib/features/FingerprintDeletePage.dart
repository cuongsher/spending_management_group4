import 'package:flutter/material.dart';
import 'SuccessPage.dart';

class FingerprintDeletePage extends StatelessWidget {
  final String name; // 👈 BẮT BUỘC PHẢI CÓ

  const FingerprintDeletePage({
    super.key,
    required this.name, // 👈 BẮT BUỘC
  });

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFDFF3EC);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Column(
        children: [
          /// HEADER
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Xóa Vân Tay",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),

          /// BODY
          Expanded(
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  const Icon(
                    Icons.fingerprint,
                    size: 90,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    name, // 👈 HIỂN THỊ ĐÚNG NGUYỄN HOÀNG
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Bạn có chắc muốn xóa vân tay này không?",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  /// DELETE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SuccessPage(
                              message: "Xóa Vân Tay Thành Công",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Xóa Vân Tay",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}