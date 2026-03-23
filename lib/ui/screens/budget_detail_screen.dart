import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../data/repository/budget_repository.dart';
import '../provider/budget_provider.dart';

class BudgetDetailScreen extends StatefulWidget {
  const BudgetDetailScreen({super.key});

  @override
  State<BudgetDetailScreen> createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  BudgetModel? _budget;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _budget = ModalRoute.of(context)?.settings.arguments as BudgetModel?;
    if (_budget != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<BudgetProvider>().loadBudgetDetail(_budget!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallbackBudget =
        _budget ??
        BudgetModel(
          userId: 1,
          categoryId: 3,
          budgetName: 'Hạn Mức',
          amount: 0,
          startDate: '',
          endDate: '',
          repeatType: 'monthly',
        );
    final provider = context.watch<BudgetProvider>();
    final detail = provider.detail;
    final spentAmount = detail?.spentAmount ?? 0;
    final progress = detail?.progress ?? 0;
    final categoryName = detail?.categoryName ?? fallbackBudget.budgetName;
    final expenses = detail?.expenses ?? const <BudgetExpenseItem>[];
    final theme = _budgetTheme(fallbackBudget.categoryId);

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
                backgroundColor: const Color(0xFF16C8A0),
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
                          Expanded(
                            child: Text(
                              fallbackBudget.budgetName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF6EE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: provider.isLoading && detail == null
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Nên Chi',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              '${fallbackBudget.amount.toStringAsFixed(0)} VND',
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF133C3C),
                                              ),
                                            ),
                                            const SizedBox(height: 14),
                                            const Text(
                                              'Thực Tế Chi',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Text(
                                              '${spentAmount.toStringAsFixed(2)} VND',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF16C8A0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: theme.color,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              theme.icon,
                                              color: Colors.white,
                                              size: 58,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              categoryName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: LinearProgressIndicator(
                                      minHeight: 18,
                                      value: progress,
                                      backgroundColor: const Color(0xFF1E4B4B),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color(0xFF16C8A0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${(progress * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          color: Color(0xFF133C3C),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${fallbackBudget.amount.toStringAsFixed(2)} VND',
                                        style: const TextStyle(
                                          color: Color(0xFF133C3C),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),
                                  const Text(
                                    'Lịch Sử Chi',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF133C3C),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: expenses.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'Chưa có khoản chi nào thuộc danh mục này',
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : ListView.separated(
                                            itemCount: expenses.length,
                                            separatorBuilder: (context, index) =>
                                                const SizedBox(height: 14),
                                            itemBuilder: (context, index) {
                                              final item = expenses[index];
                                              return Row(
                                                children: [
                                                  Container(
                                                    width: 46,
                                                    height: 46,
                                                    decoration: BoxDecoration(
                                                      color: theme.color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            16,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      theme.icon,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.note.isEmpty
                                                              ? categoryName
                                                              : item.note,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Color(
                                                                  0xFF133C3C,
                                                                ),
                                                              ),
                                                        ),
                                                        Text(
                                                          item.date,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 11,
                                                                color: Color(
                                                                  0xFF2377F0,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    '-${item.amount.toStringAsFixed(2)} VND',
                                                    style: const TextStyle(
                                                      color: Color(0xFF133C3C),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
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
