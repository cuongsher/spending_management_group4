import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../widgets/app_bottom_nav.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool accepted = false;

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
                backgroundColor: TermsScreen.primary,
                body: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 18, 20, 18),
                      child: Row(
                        children: [
                          BackButton(color: Colors.white),
                          Expanded(
                            child: Text(
                              'Điều Kiện Và Quy Định',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
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
                          color: TermsScreen.lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'MoneyLoop giúp bạn quản lý tài chính cá nhân. '
                                    'Khi sử dụng ứng dụng, bạn đồng ý tự chịu trách nhiệm '
                                    'với dữ liệu nhập vào, bảo mật thông tin đăng nhập và '
                                    'chấp nhận rằng dữ liệu có thể bị xóa khi bạn yêu cầu '
                                    'xóa tài khoản.\n\n'
                                    '1. Không chia sẻ tài khoản cho người khác.\n'
                                    '2. Chỉ nhập dữ liệu tài chính thuộc quyền quản lý của bạn.\n'
                                    '3. Mọi thay đổi mật khẩu và xóa tài khoản là hành động không thể hoàn tác.',
                                    style: TextStyle(height: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: accepted,
                                  onChanged: (value) {
                                    setState(() {
                                      accepted = value ?? false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'Tôi chấp nhận điều khoản và điều kiện',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: accepted
                                    ? () => Navigator.pop(context)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TermsScreen.primary,
                                  foregroundColor: const Color(0xFF103D3D),
                                ),
                                child: const Text('Accept'),
                              ),
                            ),
                            const SizedBox(height: 12),
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
}
