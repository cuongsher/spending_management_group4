import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repository/history_repository.dart';
import '../../router/app_router.dart';
import '../provider/history_provider.dart';
import '../widgets/app_primary_shell.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HistoryProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    final dashboard = provider.dashboard;

    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: const SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (dashboard == null) {
      return Scaffold(
        backgroundColor: Colors.grey.shade300,
        body: SafeArea(
          child: Center(
            child: Text(provider.errorMessage ?? 'Không có dữ liệu lịch sử'),
          ),
        ),
      );
    }

    return AppPrimaryShell(
      currentRoute: AppRouter.history,
      header: _buildHeader(dashboard),
      showAddButton: true,
      onAddTap: () async {
        final created =
            await Navigator.pushNamed(context, AppRouter.addTransaction)
                as bool?;
        if (created == true && mounted) {
          await this.context.read<HistoryProvider>().loadHistory(
            filter: provider.selectedFilter,
          );
        }
      },
      body: Column(
        children: [
          _filterRow(context, provider.selectedFilter),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                for (final section in dashboard.sections) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ...section.items.map((item) => _historyTile(context, item)),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(HistoryDashboardData dashboard) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lịch Sử',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF103B3B),
                  ),
                ),
              ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.white,
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
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Tổng Dư'),
                const SizedBox(height: 4),
                Text(
                  '${dashboard.balance.toStringAsFixed(2)} VND',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF103D3D),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'Tổng Thu',
                  dashboard.totalIncome,
                  const Color(0xFF16C8A0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryCard(
                  'Tổng Chi',
                  dashboard.totalExpense,
                  const Color(0xFF164BFF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, double amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 4),
          Text(
            '${amount.toStringAsFixed(2)} VND',
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  Widget _filterRow(BuildContext context, String selected) {
    return Row(
      children: [
        Expanded(
          child: _filterChip(
            context,
            label: 'Lịch Sử',
            selected: selected == 'all',
            onTap: () =>
                context.read<HistoryProvider>().loadHistory(filter: 'all'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _filterChip(
            context,
            label: 'Lịch Sử Thu',
            selected: selected == 'income',
            onTap: () =>
                context.read<HistoryProvider>().loadHistory(filter: 'income'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _filterChip(
            context,
            label: 'Lịch Sử Chi',
            selected: selected == 'expense',
            onTap: () =>
                context.read<HistoryProvider>().loadHistory(filter: 'expense'),
          ),
        ),
      ],
    );
  }

  Widget _filterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF164BFF)
              : Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : const Color(0xFF103D3D),
          ),
        ),
      ),
    );
  }

  Widget _historyTile(BuildContext context, HistoryTransactionItem item) {
    return InkWell(
      onTap: () async {
        final updated = await Navigator.pushNamed(
          context,
          AppRouter.addTransaction,
          arguments: item.transaction,
        ) as bool?;
        if (updated == true && context.mounted) {
          await context.read<HistoryProvider>().loadHistory(
            filter: context.read<HistoryProvider>().selectedFilter,
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF6FA8FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isExpense
                    ? Icons.shopping_bag_outlined
                    : Icons.payments_outlined,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2377F0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 72,
              child: Text(
                item.scheduleLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item.isExpense ? '-' : ''}${item.amount.toStringAsFixed(2)} VND',
              style: TextStyle(
                color: item.isExpense
                    ? const Color(0xFF164BFF)
                    : const Color(0xFF103D3D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
