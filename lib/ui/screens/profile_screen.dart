import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/app_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final userId = context.read<AuthProvider>().currentUserId;
      context.read<ProfileProvider>().loadProfile(userId: userId);
    });
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
                      padding: EdgeInsets.fromLTRB(24, 26, 24, 20),
                      child: Text(
                        'Cá Nhân',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF103B3B),
                        ),
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
                        child: provider.isLoading && user == null
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            user?.fullName ?? 'Người dùng',
                                            style: const TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF103D3D),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text('ID: ${user?.id ?? 0}'),
                                          const SizedBox(height: 26),
                                          _profileTile(
                                            icon: Icons.person_outline_rounded,
                                            label: 'Thông Tin Cá Nhân',
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              AppRouter.editProfile,
                                            ),
                                          ),
                                          _profileTile(
                                            icon: Icons.shield_outlined,
                                            label: 'Bảo Mật',
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              AppRouter.security,
                                            ),
                                          ),
                                          _profileTile(
                                            icon: Icons.settings_outlined,
                                            label: 'Cài Đặt',
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              AppRouter.settings,
                                            ),
                                          ),
                                          _profileTile(
                                            icon: Icons.help_outline_rounded,
                                            label: 'Trợ Giúp',
                                            onTap: () {},
                                          ),
                                          _profileTile(
                                            icon: Icons.logout_rounded,
                                            label: 'Đăng Xuất',
                                            onTap: () {
                                              context
                                                  .read<AuthProvider>()
                                                  .logout();
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                AppRouter.login,
                                                (route) => false,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const AppBottomNav(
                                    currentRoute: AppRouter.profile,
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

  Widget _profileTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF4D94FF),
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF103D3D),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
