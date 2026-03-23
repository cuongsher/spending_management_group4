import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/app_bottom_nav.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

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
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final userId = authProvider.currentUserId ?? profileProvider.user?.id;
    if (userId == null) return;

    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    // ✅ Regex
    final phoneRegex = RegExp(r'^(03|05|07|08|09)[0-9]{8}$');
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập số điện thoại')),
      );
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số điện thoại không hợp lệ')),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập email')),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email không hợp lệ')),
      );
      return;
    }

    final success = await profileProvider.updateProfile(
      userId: userId,
      fullName: _nameController.text.trim(),
      phone: phone,
      email: email,
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
                              'Thông Tin Cá Nhân',
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
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 16),
                                    const CircleAvatar(
                                      radius: 38,
                                      backgroundColor: Color(0xFF16C8A0),
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
                                    _field('Tên', _nameController),
                                    const SizedBox(height: 12),
                                    _field('Số Điện Thoại', _phoneController),
                                    const SizedBox(height: 12),
                                    _field('Email', _emailController),
                                    const SizedBox(height: 16),
                                    _switchRow(
                                      'Thông Báo Đẩy',
                                      provider.notificationsEnabled,
                                      provider.setNotificationsEnabled,
                                    ),
                                    const SizedBox(height: 18),
                                    SizedBox(
                                      width: 180,
                                      child: ElevatedButton(
                                        onPressed: provider.isLoading
                                            ? null
                                            : _save,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: primary,
                                          foregroundColor: const Color(
                                            0xFF103D3D,
                                          ),
                                        ),
                                        child: Text(
                                          provider.isLoading
                                              ? 'Đang cập nhật...'
                                              : 'Cập Nhật Thông Tin',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget _field(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

  Widget _switchRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(value: value, onChanged: onChanged, activeThumbColor: primary),
      ],
    );
  }
}
