import 'package:flutter/material.dart';

import '../../router/app_router.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/profile_flow_scaffold.dart';
import '../widgets/profile_list_tile_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <({IconData icon, String label, VoidCallback onTap})>[
      (
        icon: Icons.notifications_none_rounded,
        label: 'Thông Báo',
        onTap: () =>
            Navigator.pushNamed(context, AppRouter.notificationSettings),
      ),
      (
        icon: Icons.key_outlined,
        label: 'Mật Khẩu',
        onTap: () => Navigator.pushNamed(context, AppRouter.passwordSettings),
      ),
      (
        icon: Icons.person_remove_outlined,
        label: 'Xóa Tài Khoản',
        onTap: () => Navigator.pushNamed(context, AppRouter.deleteAccount),
      ),
    ];

    return ProfileFlowScaffold(
      title: 'Cài Đặt',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items)
            ProfileListTileCard(
              icon: item.icon,
              label: item.label,
              onTap: item.onTap,
              borderRadius: 18,
              avatarBackgroundColor: ProfileFlowTheme.primary,
              avatarIconColor: ProfileFlowTheme.actionButtonFg,
              showTrailingChevron: true,
            ),
          const Spacer(),
          const AppBottomNav(currentRoute: AppRouter.profile),
        ],
      ),
    );
  }
}
