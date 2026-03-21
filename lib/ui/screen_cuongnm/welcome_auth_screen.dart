import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../widget_cuongnm/auth_button.dart';

class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF7EC);

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
                backgroundColor: lightBg,
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 148,
                        height: 148,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9F4E7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.show_chart_rounded,
                          size: 96,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'MoneyLoop',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 42),
                      AuthButton(
                        text: 'Đăng Nhập',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.login);
                        },
                      ),
                      const SizedBox(height: 14),
                      AuthButton(
                        text: 'Đăng Ký',
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.register);
                        },
                        backgroundColor: const Color(0xFFD8EFD8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
