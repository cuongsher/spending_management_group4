import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/RecurringTransactionModel.dart';
import '../../router/app_router.dart';
import '../provider/customize_provider.dart';
import '../widgets/app_bottom_nav.dart';

class RecurringTransactionsScreen extends StatefulWidget {
  const RecurringTransactionsScreen({super.key});

  @override
  State<RecurringTransactionsScreen> createState() =>
      _RecurringTransactionsScreenState();
}

class _RecurringTransactionsScreenState
    extends State<RecurringTransactionsScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeProvider>().loadRecurringItems(type: 'expense');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomizeProvider>();

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
                    _topBar('Thu / Chi Định Kỳ'),
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
                            Row(
                              children: [
                                Expanded(
                                  child: _typeTile(
                                    label: 'Mục Thu',
                                    selected:
                                        provider.selectedRecurringType ==
                                        'income',
                                    onTap: () => context
                                        .read<CustomizeProvider>()
                                        .loadRecurringItems(type: 'income'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _typeTile(
                                    label: 'Mục Chi',
                                    selected:
                                        provider.selectedRecurringType ==
                                        'expense',
                                    onTap: () => context
                                        .read<CustomizeProvider>()
                                        .loadRecurringItems(type: 'expense'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: ListView.separated(
                                itemCount: provider.recurringItems.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final item = provider.recurringItems[index];
                                  return Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                          backgroundColor: Color(0xFF4D94FF),
                                          child: Icon(
                                            Icons.refresh_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                '${item.repeatCycle} | ${item.startDate}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '${item.amount.toStringAsFixed(2)} VND',
                                          style: const TextStyle(
                                            color: Color(0xFF16C8A0),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            AppRouter.addRecurringTransaction,
                                            arguments: RecurringTransactionModel(
                                              id: item.id,
                                              userId: item.userId,
                                              categoryId: item.categoryId,
                                              amount: item.amount,
                                              startDate: item.startDate,
                                              repeatCycle: item.repeatCycle,
                                              note: item.note,
                                            ),
                                          ),
                                          icon: const Icon(Icons.edit_outlined),
                                        ),
                                        IconButton(
                                          onPressed: () => _deleteRecurring(
                                            context,
                                            provider,
                                            item.id,
                                          ),
                                          icon: const Icon(Icons.delete_outline),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRouter.addRecurringTransaction,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: const Color(0xFF163C3C),
                                ),
                                child: const Text('Thêm Khoản'),
                              ),
                            ),
                            const SizedBox(height: 12),
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

  Future<void> _deleteRecurring(
    BuildContext context,
    CustomizeProvider provider,
    int id,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa khoản định kỳ'),
          content: const Text('Bạn có chắc muốn xóa khoản định kỳ này không?'),
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

    if (confirmed != true || !mounted) return;
    await provider.deleteRecurringTransaction(id);
  }

  Widget _topBar(String title) {
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
    );
  }

  Widget _typeTile({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF1D6FFF)
              : Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF1D6FFF),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
