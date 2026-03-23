import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/profile_provider.dart';
import '../utils/profile_session.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/profile_flow_scaffold.dart';
import '../widgets/profile_form_field.dart';
import '../widgets/profile_primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<ProfileProvider>().user;
    if (user != null && _nameController.text.isEmpty) {
      _nameController.text = user.fullName;
      _phoneController.text = user.phone;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final userId = readCurrentUserId(context);
    if (userId == null) return;

    final profileProvider = context.read<ProfileProvider>();
    final success = await profileProvider.updateProfile(
      userId: userId,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Cập nhật thông tin thành công'
              : (profileProvider.errorMessage ?? 'Cập nhật thất bại'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    return ProfileFlowScaffold(
      title: 'Thông Tin Cá Nhân',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: ProfileFlowTheme.primary,
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text('ID: ${user?.id ?? 0}'),
                  const SizedBox(height: 24),
                  ProfileFormField(label: 'Tên', controller: _nameController),
                  const SizedBox(height: 12),
                  ProfileFormField(
                    label: 'Số Điện Thoại',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  ProfileFormField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _switchRow(
                    'Thông Báo Đẩy',
                    provider.notificationsEnabled,
                    provider.setNotificationsEnabled,
                  ),
                  _switchRow(
                    'Giao Diện Tối',
                    provider.darkModeEnabled,
                    provider.setDarkModeEnabled,
                  ),
                  const SizedBox(height: 18),
                  ProfilePrimaryButton(
                    label: 'Cập Nhật Thông Tin',
                    loadingLabel: 'Đang cập nhật...',
                    isLoading: provider.isLoading,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const AppBottomNav(currentRoute: AppRouter.profile),
        ],
      ),
    );
  }

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: ProfileFlowTheme.primary,
        ),
      ],
    );
  }
}
