import 'package:flutter/material.dart';
import 'ChangePinPage.dart';
import 'DeleteAccountPage.dart';
import 'NotificationSettingsPage.dart'; // 👈 THÊM DÒNG NÀY

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const mainGreen = Color(0xFF19C49B);
    const bodyColor = Color(0xFFE8F5F0);

    return Scaffold(
      backgroundColor: mainGreen,
      body: Column(
        children: [

          /// ===== HEADER =====
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // 👈 back hoạt động
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Cài Đặt",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.notifications_none),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// ===== BODY =====
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: bodyColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [

                  /// ===== THÔNG BÁO =====
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text("Thông báo"),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const NotificationSettingsPage(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  /// ===== MẬT KHẨU → CHANGE PIN =====
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Mật khẩu"),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const ChangePinPage(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  /// ===== XOÁ TÀI KHOẢN =====
                  ListTile(
                    leading:
                    const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      "Xoá tài khoản",
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing:
                    const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const DeleteAccountPage(),
                        ),
                      );
                    },
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