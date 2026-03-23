import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/auth_provider.dart';
import '../provider/profile_provider.dart';
import '../widgets/app_primary_shell.dart';
import '../widgets/profile_flow_scaffold.dart';
import '../widgets/profile_list_tile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final auth = context.read<AuthProvider>();

    return AppPrimaryShell(
      currentRoute: AppRouter.profile,
      header: const Padding(
        padding: EdgeInsets.fromLTRB(24, 26, 24, 20),
        child: Text(
          'Cá Nhân',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: ProfileFlowTheme.profileHeaderText,
          ),
        ),
      ),
      body: provider.isLoading && user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    user?.fullName ?? 'Người dùng',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: ProfileFlowTheme.profileHeaderText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('ID: ${user?.id ?? 0}'),
                  const SizedBox(height: 26),
                  ..._menuItems(context, auth).map(
                    (item) => ProfileListTileCard(
                      icon: item.icon,
                      label: item.label,
                      onTap: item.onTap,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<({IconData icon, String label, VoidCallback onTap})> _menuItems(
    BuildContext context,
    AuthProvider auth,
  ) {
    return [
      (
        icon: Icons.person_outline_rounded,
        label: 'Thông Tin Cá Nhân',
        onTap: () => Navigator.pushNamed(context, AppRouter.editProfile),
      ),
      (
        icon: Icons.shield_outlined,
        label: 'Bảo Mật',
        onTap: () => Navigator.pushNamed(context, AppRouter.security),
      ),
      (
        icon: Icons.settings_outlined,
        label: 'Cài Đặt',
        onTap: () => Navigator.pushNamed(context, AppRouter.settings),
      ),
      (icon: Icons.help_outline_rounded, label: 'Trợ Giúp', onTap: () {}),
      (
        icon: Icons.logout_rounded,
        label: 'Đăng Xuất',
        onTap: () {
          auth.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouter.login,
            (route) => false,
          );
        },
      ),
    ];
  }
}
