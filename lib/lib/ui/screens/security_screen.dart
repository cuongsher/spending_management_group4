import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../widgets/app_bottom_nav.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 390,
            height: 800,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Scaffold(
                backgroundColor: primary,
                body: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 18, 20, 18),
                      child: Row(
                        children: [
                          BackButton(color: Colors.white),
                          Expanded(
                            child: Text(
                              'Bảo Mật',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF113939),
                              ),
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            _securityTile(
                              context,
                              label: 'Thay Đổi Mật Khẩu',
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRouter.passwordSettings,
                              ),
                            ),
                            _securityTile(
                              context,
                              label: 'Mã Hóa Vân Tay',
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRouter.fingerprint,
                              ),
                            ),
                            _securityTile(
                              context,
                              label: 'Điều Kiện Và Quy Định',
                              onTap: () =>
                                  Navigator.pushNamed(context, AppRouter.terms),
                            ),
                            const Spacer(),
                            const AppBottomNav(currentRoute: AppRouter.profile),
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

  Widget _securityTile(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
