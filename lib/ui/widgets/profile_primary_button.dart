import 'package:flutter/material.dart';

import 'profile_flow_scaffold.dart';

class ProfilePrimaryButton extends StatelessWidget {
  const ProfilePrimaryButton({
    super.key,
    required this.label,
    required this.loadingLabel,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final String loadingLabel;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfileFlowTheme.primary,
          foregroundColor: ProfileFlowTheme.actionButtonFg,
        ),
        child: Text(isLoading ? loadingLabel : label),
      ),
    );
  }
}
