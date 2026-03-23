import 'package:flutter/material.dart';

import '../../router/app_router.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.currentRoute});

  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF0DE),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: currentRoute == AppRouter.home,
              onTap: () => _go(context, AppRouter.home),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.bar_chart_rounded,
              label: 'Báo Cáo',
              selected: currentRoute == AppRouter.report,
              onTap: () => _go(context, AppRouter.report),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.sync_alt_rounded,
              label: 'Lịch Sử',
              selected: currentRoute == AppRouter.history,
              onTap: () => _go(context, AppRouter.history),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.layers_rounded,
              label: 'Tùy Chỉnh',
              selected: currentRoute == AppRouter.customize,
              onTap: () => _go(context, AppRouter.customize),
            ),
          ),
          Expanded(
            child: _NavItem(
              icon: Icons.person_outline_rounded,
              label: 'Cá Nhân',
              selected: currentRoute == AppRouter.profile,
              onTap: () => _go(context, AppRouter.profile),
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.pushReplacementNamed(context, route);
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF16C8A0) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF163C3C)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Color(0xFF163C3C)),
          ),
        ],
      ),
    );
  }
}
