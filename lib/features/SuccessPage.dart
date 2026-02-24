import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String message;

  const SuccessPage({
    super.key,
    required this.message,
  });

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
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
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
                  const Icon(Icons.check_circle,
                      color: mainGreen, size: 100),

                  const SizedBox(height: 20),

                  Text(
                    message,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                          context, (route) => route.isFirst);
                    },
                    child: const Text(
                      "Quay Về Trang Chính",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}