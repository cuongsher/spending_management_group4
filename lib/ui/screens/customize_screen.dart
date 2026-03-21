import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();
    final dashboard = provider.dashboard;

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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tùy Chỉnh',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF103B3B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _summaryTile(
                                  'Tổng Dư',
                                  dashboard?.totalBalance ?? 0,
                                  Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _summaryTile(
                                  'Tổng Chi',
                                  dashboard?.totalExpense ?? 0,
                                  const Color(0xFF164BFF),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: LinearProgressIndicator(
                              minHeight: 18,
                              value: dashboard?.spendingProgress ?? 0,
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF153C3C),
                              ),
                            ),
                          ),
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
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                children: [
                                  _menuTile(
                                    icon: Icons.menu_rounded,
                                    label: 'Hạng Mục\nThu / Chi',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.categoryManagement,
                                    ),
                                  ),
                                  _menuTile(
                                    icon: Icons.account_balance_wallet_outlined,
                                    label: 'Hạn Mức Chi',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.budgetList,
                                    ),
                                  ),
                                  _menuTile(
                                    icon: Icons.receipt_long_outlined,
                                    label: 'Khoản Thu/Chi\nĐịnh Kỳ',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.recurringTransactions,
                                    ),
                                  ),
                                  _menuTile(
                                    icon: Icons.savings_outlined,
                                    label: 'Quản Lý\nTài Sản',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.assetList,
                                    ),
                                  ),
                                  _menuTile(
                                    icon: Icons.shopping_bag_outlined,
                                    label: 'Danh Sách\nMua Sắm',
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.shoppingList,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 72,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFF143C3C),
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFF143C3C),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const AppBottomNav(
                              currentRoute: AppRouter.customize,
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

  Widget _summaryTile(String title, double amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} VND',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
        ),
      ],
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF79AFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: const Color(0xFF163C3C)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF163C3C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
