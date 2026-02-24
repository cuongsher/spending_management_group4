import 'package:flutter/material.dart';
import 'ChangePinPage.dart';
import 'FingerprintPage.dart';
import 'TermsAndConditionsPage.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1ABC9C),
      body: Column(
        children: [
          const SizedBox(height: 60),

          const Text(
            "Security",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5F0),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [

                  /// CHANGE PIN
                  ListTile(
                    title: const Text("Thay Đổi Mật Khẩu"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePinPage(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  /// FINGERPRINT (GIỮ NGUYÊN FLOW CŨ)
                  ListTile(
                    title: const Text("Mã Hóa Vân Tay"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FingerprintPage(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  /// TERMS
                  ListTile(
                    title: const Text("Terms And Conditions"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const TermsAndConditionsPage(),
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