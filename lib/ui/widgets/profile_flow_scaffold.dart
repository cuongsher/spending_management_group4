import 'package:flutter/material.dart';

/// Colors and layout shared by profile sub-screens (edit, password, settings, …).
abstract final class ProfileFlowTheme {
  ProfileFlowTheme._();

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);
  static const Color titleBarText = Color(0xFF113939);
  static const Color actionButtonFg = Color(0xFF103D3D);
  static const Color fieldFill = Color(0xFFDFF1E1);
  static const Color profileHeaderText = Color(0xFF103D3D);
}

/// Phone-frame style shell: grey backdrop, rounded card, teal header + light body.
class ProfileFlowScaffold extends StatelessWidget {
  const ProfileFlowScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
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
                backgroundColor: ProfileFlowTheme.primary,
                body: Column(
                  children: [
                    ProfileFlowTitleBar(title: title),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                        decoration: const BoxDecoration(
                          color: ProfileFlowTheme.lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: body,
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
}

class ProfileFlowTitleBar extends StatelessWidget {
  const ProfileFlowTitleBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
      child: Row(
        children: [
          const BackButton(color: Colors.white),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: ProfileFlowTheme.titleBarText,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
