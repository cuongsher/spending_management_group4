import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../router/app_router.dart';
import '../provider/budget_provider.dart';
import '../widgets/app_bottom_nav.dart';

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
                            onPressed: () => Navigator.pop(context),
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
                                              final spent = provider
                                                      .spentByCategory[budget
                                                          .categoryId] ??
                                                  0;
                                              return _BudgetTile(
                                                budget: budget,
                                                spentAmount: spent,
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    AppRouter.budgetDetail,
                                                    arguments: budget,
                                                  );
                                                },
                                                onEdit: () async {
                                                  final updated =
                                                      await Navigator.pushNamed(
                                                            context,
                                                            AppRouter.addBudget,
                                                            arguments: budget,
                                                          )
                                                          as bool?;
                                                  if (updated == true && mounted) {
                                                    await this.context
                                                        .read<BudgetProvider>()
                                                        .loadBudgets();
                                                  }
                                                },
                                                onDelete: () => _deleteBudget(
                                                  context,
                                                  budget,
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final created =
                                            await Navigator.pushNamed(
                                                  context,
                                                  AppRouter.addBudget,
                                                )
                                                as bool?;
                                        if (created == true && mounted) {
                                          await this.context
                                              .read<BudgetProvider>()
                                              .loadBudgets();
                                        }
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

  Future<void> _deleteBudget(BuildContext context, BudgetModel budget) async {
    final provider = context.read<BudgetProvider>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa hạn mức'),
          content: Text('Bạn có chắc muốn xóa "${budget.budgetName}" không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted || budget.id == null) return;
    await provider.deleteBudget(budget.id!);
  }
}

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({
    required this.budget,
    required this.spentAmount,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final BudgetModel budget;
  final double spentAmount;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = budget.amount <= 0
        ? 0.0
        : (spentAmount / budget.amount).clamp(0.0, 1.0);
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        budget.budgetName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF133C3C),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: const Color(0xFF153C3C),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.red,
                    ),
                  ],
                ),
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

({IconData icon, Color color}) _budgetTheme(int categoryId) {
  switch (categoryId) {
    case 3:
      return (icon: Icons.restaurant_rounded, color: const Color(0xFF7EB8FF));
    case 4:
      return (icon: Icons.shopping_bag_outlined, color: const Color(0xFF79AFFF));
    case 5:
      return (icon: Icons.home_work_outlined, color: const Color(0xFF79AFFF));
    default:
      return (icon: Icons.school_outlined, color: const Color(0xFF79AFFF));
  }
}
