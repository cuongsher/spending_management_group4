import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/app_bottom_nav.dart';

class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final userId = authProvider.currentUserId ?? profileProvider.user?.id;
    if (userId == null) return;

    final success = await profileProvider.updatePassword(
      userId: userId,
      currentPassword: _currentController.text.trim(),
      newPassword: _newController.text.trim(),
      confirmPassword: _confirmController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushNamed(context, AppRouter.passwordChanged);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(profileProvider.errorMessage ?? 'Không thể đổi mật khẩu'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

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
                              'Cài Đặt Mật Khẩu',
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
                            _field('Mật Khẩu Hiện Tại', _currentController),
                            const SizedBox(height: 14),
                            _field('Mật Khẩu Mới', _newController),
                            const SizedBox(height: 14),
                            _field('Xác Nhận Mật Khẩu', _confirmController),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: provider.isLoading ? null : _save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: const Color(0xFF103D3D),
                                ),
                                child: Text(
                                  provider.isLoading
                                      ? 'Đang xử lý...'
                                      : 'Thay Đổi Mật Khẩu',
                                ),
                              ),
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

  Widget _field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFDFF1E1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
