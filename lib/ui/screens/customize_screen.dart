import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_primary_shell.dart';

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key});

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
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

    return AppPrimaryShell(
      currentRoute: AppRouter.customize,
      header: Padding(
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
                valueColor: const AlwaysStoppedAnimation(Color(0xFF153C3C)),
              ),
            ),
          ],
        ),
      ),
      showAddButton: true,
      onAddTap: () async {
        final created =
            await Navigator.pushNamed(context, AppRouter.addTransaction)
                as bool?;
        if (created == true && mounted) {
          await this.context.read<CustomizeProvider>().loadDashboard();
        }
      },
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
        children: [
          _menuTile(
            icon: Icons.menu_rounded,
            label: 'Hạng Mục\nThu / Chi',
            onTap: () => Navigator.pushNamed(context, AppRouter.categoryManagement),
          ),
          _menuTile(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Hạn Mức Chi',
            onTap: () => Navigator.pushNamed(context, AppRouter.budgetList),
          ),
          _menuTile(
            icon: Icons.receipt_long_outlined,
            label: 'Khoản Thu/Chi\nĐịnh Kỳ',
            onTap: () =>
                Navigator.pushNamed(context, AppRouter.recurringTransactions),
          ),
          _menuTile(
            icon: Icons.savings_outlined,
            label: 'Quản Lý\nTài Sản',
            onTap: () => Navigator.pushNamed(context, AppRouter.assetList),
          ),
          _menuTile(
            icon: Icons.shopping_bag_outlined,
            label: 'Danh Sách\nMua Sắm',
            onTap: () => Navigator.pushNamed(context, AppRouter.shoppingList),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF79AFFF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: const Color(0xFF163C3C)),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
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
