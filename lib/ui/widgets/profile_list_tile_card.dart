import 'package:flutter/material.dart';

/// Rounded list row used on profile home and settings-style screens.
class ProfileListTileCard extends StatelessWidget {
  const ProfileListTileCard({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.borderRadius = 20,
    this.avatarBackgroundColor = const Color(0xFF4D94FF),
    this.avatarIconColor = Colors.white,
    this.showTrailingChevron = false,
    this.titleStyle = const TextStyle(
      fontWeight: FontWeight.w700,
      color: Color(0xFF103D3D),
    ),
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double borderRadius;
  final Color avatarBackgroundColor;
  final Color avatarIconColor;
  final bool showTrailingChevron;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarBackgroundColor,
          child: Icon(icon, color: avatarIconColor),
        ),
        title: Text(label, style: titleStyle),
        trailing: showTrailingChevron
            ? const Icon(Icons.chevron_right_rounded)
            : null,
        onTap: onTap,
      ),
    );
  }
}
