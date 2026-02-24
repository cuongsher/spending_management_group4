import 'package:flutter/material.dart';
import 'SuccessPage.dart';

class FingerprintAddPage extends StatelessWidget {
  const FingerprintAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFDFF3EC);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  const Text("Thêm Vân Tay",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF19C49B),
                    child: Icon(Icons.fingerprint,
                        size: 60, color: Colors.white),
                  ),

                  const SizedBox(height: 20),

                  const Text("Dùng Vân Tay Để Truy Cập",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 40),

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                              const SuccessPage(
                                  message:
                                  "Vân Tay Đã Được Thay Đổi")),
                        );
                      },
                      child: const Text("Dùng Vân Tay",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}