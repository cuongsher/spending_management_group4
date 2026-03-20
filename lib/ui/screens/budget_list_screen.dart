import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../router/app_router.dart';
import '../provider/budget_provider.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BudgetProvider>().loadBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BudgetProvider>();
    final budgets = provider.budgets;

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
                      padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.white,
                          ),
                          const Expanded(
                            child: Text(
                              'Hạn Mức Chi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF113939),
                              ),
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              size: 18,
                              color: Color(0xFF155050),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
                        decoration: const BoxDecoration(
                          color: lightBg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: provider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  Expanded(
                                    child: budgets.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Chưa có hạn mức nào',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          )
                                        : ListView.separated(
                                            itemCount: budgets.length,
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(height: 16),
                                            itemBuilder: (context, index) {
                                              final budget = budgets[index];
                                              return _BudgetTile(
                                                budget: budget,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AppRouter.budgetDetail,
                                                    arguments: budget,
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRouter.addBudget,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                        foregroundColor: const Color(0xFF123E3E),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                      ),
                                      child: const Text('Thêm Hạn Mức'),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const _BudgetNavBar(),
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
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({
    required this.budget,
    required this.onTap,
  });

  final BudgetModel budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = budget.amount <= 0
        ? 0.0
        : ((budget.amount % 100000) / 100000).clamp(0.0, 0.95);
    final theme = _budgetTheme(budget.categoryId);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(theme.icon, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.budgetName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF133C3C),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${budget.startDate} - ${budget.endDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2377F0),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    minHeight: 14,
                    value: progress,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF153C3C)),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF153C3C),
                      ),
                    ),
                    Text(
                      '${budget.amount.toStringAsFixed(2)} VND',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF153C3C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 22,
            color: Color(0xFF153C3C),
          ),
        ],
      ),
    );
  }
}

class _BudgetNavBar extends StatelessWidget {
  const _BudgetNavBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF0DE),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home'),
          _NavItem(icon: Icons.bar_chart_rounded, label: 'Báo Cáo'),
          _NavItem(icon: Icons.sync_alt_rounded, label: 'Lịch Sử'),
          _NavItem(
            icon: Icons.layers_rounded,
            label: 'Tùy Chỉnh',
            selected: true,
          ),
          _NavItem(icon: Icons.person_outline_rounded, label: 'Cá Nhân'),
          _NavItem(icon: Icons.card_giftcard_rounded, label: 'Thử Thách'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF16C8A0) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF163C3C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF163C3C)),
        ),
      ],
    );
  }
}

({IconData icon, Color color}) _budgetTheme(int categoryId) {
  switch (categoryId) {
    case 1:
      return (icon: Icons.restaurant_rounded, color: const Color(0xFF7EB8FF));
    case 2:
      return (icon: Icons.card_giftcard_rounded, color: const Color(0xFF79AFFF));
    case 3:
      return (icon: Icons.flight_takeoff_rounded, color: const Color(0xFF79AFFF));
    default:
      return (icon: Icons.directions_car_rounded, color: const Color(0xFF79AFFF));
  }
}
