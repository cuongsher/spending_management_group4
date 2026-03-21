import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spending_management_group4/ui/screen_ngan/screen_add_transaction.dart';
import 'package:spending_management_group4/ui/screen_ngan/screen_edit_transaction.dart';
import '../../controller/report/controller_history.dart';
import '../../data/database/model1/TransactionModel.dart';
import '../../provider/provider_ngan/transactionProvider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> with WidgetsBindingObserver {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final repo = ref.read(transactionRepoProvider);
    _controller = HistoryController(repo);
    _controller.load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _controller.load();
  }

  Future<void> _openAdd() async {
    await Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
    if (!mounted) return;
    _controller.load();
  }

  String _formatMoney(int amount) {
    final s = amount.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} Vnd';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAdd,
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListenableBuilder(
        listenable: _controller,
        builder: (_, __) {
          if (_controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final all = _controller.all;
          final totalIncome = all
              .where((e) => e.type == TransactionType.income)
              .fold<int>(0, (s, e) => s + e.amount);
          final totalExpense = all
              .where((e) => e.type == TransactionType.expense)
              .fold<int>(0, (s, e) => s + e.amount);
          final balance = totalIncome - totalExpense;
          final items = _controller.items;

          return Column(
            children: [
              _HistoryHeader(
                balance: balance,
                totalIncome: totalIncome,
                totalExpense: totalExpense,
                filter: _controller.filter,
                onFilterChanged: _controller.changeFilter,
                formatMoney: _formatMoney,
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Chưa có giao dịch'))
                    : _GroupedList(
                  items: items,
                  onChanged: _controller.load,
                  formatMoney: _formatMoney,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _HistoryHeader extends StatelessWidget {
  final int balance, totalIncome, totalExpense;
  final HistoryFilter filter;
  final ValueChanged<HistoryFilter> onFilterChanged;
  final String Function(int) formatMoney;

  const _HistoryHeader({
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    required this.filter,
    required this.onFilterChanged,
    required this.formatMoney,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // AppBar row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text('Lịch Sử',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Balance card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text('Tổng Dư',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(formatMoney(balance),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Thu / Chi filter tiles
            Row(
              children: [
                Expanded(
                  child: _FilterTile(
                    label: 'Tổng Thu',
                    value: formatMoney(totalIncome),
                    icon: Icons.arrow_circle_up_outlined,
                    selected: filter == HistoryFilter.income,
                    onTap: () => onFilterChanged(
                      filter == HistoryFilter.income ? HistoryFilter.all : HistoryFilter.income,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FilterTile(
                    label: 'Tổng Chi',
                    value: formatMoney(totalExpense),
                    icon: Icons.arrow_circle_down_outlined,
                    selected: filter == HistoryFilter.expense,
                    onTap: () => onFilterChanged(
                      filter == HistoryFilter.expense ? HistoryFilter.all : HistoryFilter.expense,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withValues(alpha: 0.2) : scheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: selected ? Colors.white : scheme.primary, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: selected ? Colors.white70 : Colors.black54)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: selected ? Colors.white : Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Grouped List ─────────────────────────────────────────────────────────────

class _GroupedList extends StatelessWidget {
  final List<Transaction> items;
  final VoidCallback onChanged;
  final String Function(int) formatMoney;

  const _GroupedList({
    required this.items,
    required this.onChanged,
    required this.formatMoney,
  });

  static const _monthNames = [
    '', 'Tháng Một', 'Tháng Hai', 'Tháng Ba', 'Tháng Tư',
    'Tháng Năm', 'Tháng Sáu', 'Tháng Bảy', 'Tháng Tám',
    'Tháng Chín', 'Tháng Mười', 'Tháng Mười Một', 'Tháng Mười Hai',
  ];

  @override
  Widget build(BuildContext context) {
    final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));

    // Group by year-month
    final groups = <String, List<Transaction>>{};
    for (final tx in sorted) {
      final key = '${_monthNames[tx.date.month]}|${tx.date.year}';
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final keys = groups.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final parts = keys[i].split('|');
        final monthLabel = parts[0];
        final list = groups[keys[i]]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthLabel,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bar_chart, size: 16, color: Colors.green),
                  ),
                ],
              ),
            ),
            ...list.map((tx) => _TxRow(tx: tx, onChanged: onChanged, formatMoney: formatMoney)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

// ─── Transaction Row ──────────────────────────────────────────────────────────

class _TxRow extends StatelessWidget {
  final Transaction tx;
  final VoidCallback onChanged;
  final String Function(int) formatMoney;

  const _TxRow({required this.tx, required this.onChanged, required this.formatMoney});

  static const _categoryIcons = <String, IconData>{
    'Lương': Icons.monetization_on_outlined,
    'Mua Sắm': Icons.shopping_bag_outlined,
    'Ăn Uống': Icons.restaurant_outlined,
    'Giao Thông': Icons.directions_bus_outlined,
    'Thuế': Icons.receipt_long_outlined,
    'Khác': Icons.category_outlined,
  };

  static const _categoryColors = <String, Color>{
    'Lương': Color(0xFF00C49A),
    'Mua Sắm': Color(0xFF1565C0),
    'Ăn Uống': Color(0xFFFF7043),
    'Giao Thông': Color(0xFF7B61FF),
    'Thuế': Color(0xFFFF9800),
    'Khác': Color(0xFF00C49A),
  };

  String _timeLabel() {
    final d = tx.date;
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    return '$h:$m - ${d.day}/${d.month.toString().padLeft(2, '0')}';
  }

  String _freqLabel() {
    if (tx.note != null && tx.note!.isNotEmpty) return tx.note!;
    return tx.type == TransactionType.income ? 'Hàng tháng' : 'Thường xuyên';
  }

  @override
  Widget build(BuildContext context) {
    final isExpense = tx.type == TransactionType.expense;
    final color = _categoryColors[tx.category] ?? const Color(0xFF00C49A);
    final icon = _categoryIcons[tx.category] ?? Icons.swap_horiz;
    final amountColor = isExpense ? const Color(0xFF1565C0) : Colors.black87;
    final amountText = isExpense
        ? '-${formatMoney(tx.amount)}'
        : formatMoney(tx.amount);

    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EditTransactionScreen(transaction: tx)),
        );
        if (result == 'updated' || result == 'deleted') onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            // Category + time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.category,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(_timeLabel(),
                      style: const TextStyle(color: Colors.black45, fontSize: 11)),
                ],
              ),
            ),
            // Frequency label
            Text(_freqLabel(),
                style: const TextStyle(color: Colors.black38, fontSize: 11)),
            const SizedBox(width: 8),
            // Amount
            Text(amountText,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: amountColor)),
          ],
        ),
      ),
    );
  }
}
