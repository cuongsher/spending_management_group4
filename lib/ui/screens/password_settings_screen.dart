import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/profile_provider.dart';
import '../utils/profile_session.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/profile_flow_scaffold.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/profile_primary_button.dart';

class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _PasswordSettingsScreenState();
}

class _PasswordSettingsScreenState extends State<PasswordSettingsScreen> {
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
    final userId = readCurrentUserId(context);
    if (userId == null) return;

    final profileProvider = context.read<ProfileProvider>();
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

    return ProfileFlowScaffold(
      title: 'Cài Đặt Mật Khẩu',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileFormField(
            label: 'Mật Khẩu Hiện Tại',
            controller: _currentController,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          ProfileFormField(
            label: 'Mật Khẩu Mới',
            controller: _newController,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          ProfileFormField(
            label: 'Xác Nhận Mật Khẩu',
            controller: _confirmController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ProfilePrimaryButton(
            label: 'Thay Đổi Mật Khẩu',
            loadingLabel: 'Đang xử lý...',
            isLoading: provider.isLoading,
            onPressed: _save,
          ),
          const Spacer(),
          const AppBottomNav(currentRoute: AppRouter.profile),
        ],
      ),
    );
  }
}
