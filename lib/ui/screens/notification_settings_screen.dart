import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/profile_provider.dart';
import '../widgets/app_bottom_nav.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

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
                              'Cài Đặt Thông Báo',
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
                            _toggleRow(
                              'Thông Tin Chung',
                              provider.generalNotifications,
                              provider.setGeneralNotifications,
                            ),
                            _toggleRow(
                              'Âm Thanh',
                              provider.soundEnabled,
                              provider.setSoundEnabled,
                            ),
                            _toggleRow(
                              'Thông Báo Gọi',
                              provider.callNotifications,
                              provider.setCallNotifications,
                            ),
                            _toggleRow(
                              'Rung',
                              provider.vibrationEnabled,
                              provider.setVibrationEnabled,
                            ),
                            _toggleRow(
                              'Thay Đổi Giao Dịch',
                              provider.transactionChanges,
                              provider.setTransactionChanges,
                            ),
                            _toggleRow(
                              'Thông Báo Giao Dịch',
                              provider.transactionNotifications,
                              provider.setTransactionNotifications,
                            ),
                            _toggleRow(
                              'Cảnh Báo Vượt Ngân Sách',
                              provider.budgetWarnings,
                              provider.setBudgetWarnings,
                            ),
                            const Spacer(),
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

  Widget _toggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(value: value, onChanged: onChanged, activeThumbColor: primary),
      ],
    );
  }
}
