import 'package:flutter/material.dart';

import '../../data/database/model1/BudgetModel.dart';

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({super.key});

  double _spentAmount(double amount) {
    if (amount <= 0) return 0;
    return amount / 117;
  }

  @override
  Widget build(BuildContext context) {
    final budget =
        ModalRoute.of(context)?.settings.arguments as BudgetModel?;
    final item = budget ??
        BudgetModel(
          userId: 1,
          categoryId: 2,
          budgetName: 'Quà Tặng',
          amount: 34700,
          startDate: '18/10',
          endDate: '31/10',
          repeatType: 'monthly',
        );
    final spentAmount = _spentAmount(item.amount);

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
                              item.budgetName,
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
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF6EE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(42),
                            topRight: Radius.circular(42),
                          ),
                        ),
                        child: Column(
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
                                        '${item.amount.toStringAsFixed(0)} VND',
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
                                    color: const Color(0xFF79AFFF),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.card_giftcard_rounded,
                                        color: Colors.white,
                                        size: 58,
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        'Quà Tặng',
                                        style: TextStyle(
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
                                value: 0.3,
                                backgroundColor: const Color(0xFF1E4B4B),
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF16C8A0),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.amount <= 0 ? '0%' : '30%',
                                  style: const TextStyle(
                                    color: Color(0xFF133C3C),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${item.amount.toStringAsFixed(2)} VND',
                                  style: const TextStyle(
                                    color: Color(0xFF133C3C),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Tháng 10',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF133C3C),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.separated(
                                itemCount: 4,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 14),
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 46,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF79AFFF),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: const Icon(
                                          Icons.card_giftcard_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Quà Tặng',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF133C3C),
                                              ),
                                            ),
                                            Text(
                                              '12:25 - 15/10',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xFF2377F0),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '-${(spentAmount / (index + 1)).abs().toStringAsFixed(2)} VND',
                                        style: const TextStyle(
                                          color: Color(0xFF133C3C),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
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
