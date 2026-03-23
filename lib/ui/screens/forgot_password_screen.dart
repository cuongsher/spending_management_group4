import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.forgotPassword(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRouter.newPassword);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authProvider.errorMessage ?? 'Không tìm thấy email'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

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
                    const SizedBox(height: 48),
                    const Text(
                      'Quên Mật Khẩu',
                      style: TextStyle(
                        fontSize: 32,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            AuthTextField(
                              label: 'Nhập Email',
                              hintText: 'example@example.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 32),
                            AuthButton(
                              text: authProvider.isLoading
                                  ? 'Đang xử lý...'
                                  : 'Tiếp',
                              onPressed:
                                  authProvider.isLoading ? null : _handleNext,
                            ),
                            const SizedBox(height: 28),
                            AuthButton(
                              text: 'Đăng Ký',
                              onPressed: () {
                                Navigator.pushNamed(context, AppRouter.register);
                              },
                              backgroundColor: const Color(0xFFDCEEDC),
                            ),
                            const SizedBox(height: 18),
                            const Center(
                              child: Text(
                                'Hoặc đăng ký bằng',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialIcon(Icons.facebook_outlined),
                                const SizedBox(width: 16),
                                _buildSocialIcon(Icons.g_mobiledata),
                              ],
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

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black54, width: 1),
      ),
      child: Icon(
        icon,
        size: 22,
        color: Colors.black54,
      ),
    );
  }
}
