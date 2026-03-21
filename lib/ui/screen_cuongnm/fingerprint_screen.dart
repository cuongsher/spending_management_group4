import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../widget_cuongnm/auth_button.dart';

class FingerprintScreen extends StatelessWidget {
  const FingerprintScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 360,
            height: 720,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Scaffold(
                backgroundColor: primary,
                body: Column(
                  children: [
                    const SizedBox(height: 56),
                    const Text(
                      'Mở Khóa Vân Tay',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 42),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(28, 46, 28, 24),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: primary,
                              ),
                              child: const Icon(
                                Icons.fingerprint_rounded,
                                size: 88,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 28),
                            const Text(
                              'Mở khóa vân tay',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF113A3A),
                              ),
                            ),
                            const SizedBox(height: 36),
                            AuthButton(
                              text: 'Mở Khóa Vân Tay',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.budgetList,
                                );
                              },
                              backgroundColor: const Color(0xFFD7EDD6),
                            ),
                            const SizedBox(height: 14),
                            AuthButton(
                              text: 'Quay Lại Đăng Nhập',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
