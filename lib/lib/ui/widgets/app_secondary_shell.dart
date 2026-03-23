import 'package:flutter/material.dart';

class AppSecondaryShell extends StatelessWidget {
  const AppSecondaryShell({
    super.key,
    required this.primaryColor,
    required this.header,
    required this.body,
  });

  final Color primaryColor;
  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final maxWidth = isLandscape
                ? constraints.maxWidth.clamp(0.0, 900.0)
                : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  maxHeight: constraints.maxHeight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isLandscape ? 24 : 0),
                  child: Scaffold(
                    backgroundColor: primaryColor,
                    body: Column(
                      children: [
                        header,
                        Expanded(child: body),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
