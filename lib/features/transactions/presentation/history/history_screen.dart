import 'package:flutter/material.dart';
import '../../../../app/app_scope.dart';
import '../../domain/models/transaction.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../edit_transaction/edit_transaction_screen.dart';
import 'history_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController(AppScope.transactionRepo);
    _controller.load();
  }

  Future<void> _openAdd() async {
    final result = await Navigator.of(context).pushNamed(
      AddTransactionScreen.routeName,
    );

    if (!mounted) return;

    if (result == 'created') {
      _controller.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (_, __) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.error != null) {
            return Center(child: Text(_controller.error!));
          }

          final items = _controller.items;

          final totalIncome = items
              .where((e) => e.type == TransactionType.income)
              .fold<int>(0, (s, e) => s + e.amount);

          final totalExpense = items
              .where((e) => e.type == TransactionType.expense)
              .fold<int>(0, (s, e) => s + e.amount);

          final balance = totalIncome - totalExpense;

          return Column(
            children: [
              const _HeaderGreen(title: 'Lịch sử'),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  children: [
                    _BalanceCard(balance: balance),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStatCard(
                            title: 'Tổng thu',
                            value: totalIncome,
                            accent: Colors.teal,
                            icon: Icons.trending_up,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MiniStatCard(
                            title: 'Tổng chi',
                            value: totalExpense,
                            accent: Colors.blue,
                            icon: Icons.trending_down,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildFilterFigma(context),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Chưa có giao dịch'))
                    : _HistoryListGrouped(
                        items: items,
                        onChanged: () => _controller.load(),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterFigma(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _filterPill(context, 'Tất cả', HistoryFilter.all)),
        const SizedBox(width: 10),
        Expanded(child: _filterPill(context, 'Thu', HistoryFilter.income)),
        const SizedBox(width: 10),
        Expanded(child: _filterPill(context, 'Chi', HistoryFilter.expense)),
      ],
    );
  }

  Widget _filterPill(BuildContext context, String text, HistoryFilter value) {
    final selected = _controller.filter == value;
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _controller.changeFilter(value),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? scheme.primary.withOpacity(0.18) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12.withOpacity(0.08)),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? scheme.primary : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _HeaderGreen extends StatelessWidget {
  final String title;
  const _HeaderGreen({required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          children: [
            const Text(
              'Tổng Dư',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '$balance Vnd',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final int value;
  final Color accent;
  final IconData icon;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accent, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    '$value Vnd',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryListGrouped extends StatelessWidget {
  final List<Transaction> items;
  final VoidCallback onChanged;

  const _HistoryListGrouped({
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));

    final groups = <String, List<Transaction>>{};
    for (final tx in sorted) {
      final key = 'Tháng ${tx.date.month}';
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final keys = groups.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: keys.length,
      itemBuilder: (_, index) {
        final title = keys[index];
        final list = groups[title]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 8),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            ...list.map((tx) => _HistoryRow(tx: tx, onChanged: onChanged)),
          ],
        );
      },
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final Transaction tx;
  final VoidCallback onChanged;

  const _HistoryRow({
    required this.tx,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = tx.type == TransactionType.expense;
    final amountColor = isExpense ? Colors.blue : Colors.black87;

    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => EditTransactionScreen(transaction: tx),
          ),
        );
        if (result == 'updated' || result == 'deleted') onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.category,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tx.date.day}/${tx.date.month}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              (isExpense ? '-' : '') + '${tx.amount} Vnd',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}