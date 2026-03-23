import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class AppPrimaryShell extends StatelessWidget {
  const AppPrimaryShell({
    super.key,
    required this.currentRoute,
    required this.header,
    required this.body,
    this.showAddButton = false,
    this.onAddTap,
    this.primaryColor = const Color(0xFF16C8A0),
    this.bodyColor = const Color(0xFFEAF6EE),
  });

  final String currentRoute;
  final Widget header;
  final Widget body;
  final bool showAddButton;
  final VoidCallback? onAddTap;
  final Color primaryColor;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final shellWidth = isLandscape
                ? constraints.maxWidth.clamp(0.0, 900.0)
                : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: shellWidth,
                  maxHeight: constraints.maxHeight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isLandscape ? 24 : 0),
                  child: Scaffold(
                    backgroundColor: primaryColor,
                    body: Column(
                      children: [
                        header,
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                  isLandscape ? 28 : 18,
                                  18,
                                  isLandscape ? 28 : 18,
                                  showAddButton ? 120 : 88,
                                ),
                                decoration: BoxDecoration(
                                  color: bodyColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: body,
                              ),
                              Positioned(
                                left: isLandscape ? 28 : 18,
                                right: isLandscape ? 28 : 18,
                                bottom: 12,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (showAddButton) ...[
                                      Center(
                                        child: GestureDetector(
                                          onTap: onAddTap,
                                          child: Container(
                                            width: 72,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xFF143C3C),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              color: Color(0xFF143C3C),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    AppBottomNav(currentRoute: currentRoute),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
