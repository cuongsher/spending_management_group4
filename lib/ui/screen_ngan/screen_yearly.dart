import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/report/controller_report_yearly.dart';
import '../../provider/provider_ngan/transactionProvider.dart';


class ReportYearlyScreen extends ConsumerStatefulWidget {
  const ReportYearlyScreen({super.key});

  @override
  ConsumerState<ReportYearlyScreen> createState() => _ReportYearlyScreenState();
}

// 2. Đổi thành ConsumerState
class _ReportYearlyScreenState extends ConsumerState<ReportYearlyScreen> {
  late final ReportYearlyController _controller;
  int _year = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // 3. Lấy repository_cuongnm từ Riverpod thay vì AppScope
    final repo = ref.read(transactionRepoProvider);
    _controller = ReportYearlyController(repo);
    _controller.loadYear(_year);
  }

  void _prevYear() {
    setState(() => _year -= 1);
    _controller.loadYear(_year);
  }

  void _nextYear() {
    setState(() => _year += 1);
    _controller.loadYear(_year);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (_, __) {
        if (_controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final summary = _controller.summary;
        final income = summary?.totalIncome ?? 0;
        final expense = summary?.totalExpense ?? 0;
        final balance = summary?.balance ?? 0;

        return Scaffold(
          body: Column(
            children: [
              _ReportHeader(
                title: 'Báo cáo',
                leftLabel: 'Tổng Dư',
                leftValue: '$balance Vnd',
                rightLabel: 'Tổng Chi',
                rightValue: '-$expense Vnd',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 14, bottom: 16),
                    child: Column(
                      children: [
                        _WhitePanel(
                          child: Column(
                            children: [
                              const _PillTabBar(),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: _prevYear,
                                    icon: const Icon(Icons.chevron_left),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'Năm $_year',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: _nextYear,
                                    icon: const Icon(Icons.chevron_right),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const _SectionTitle(title: 'Thu Nhập & Chi Tiêu'),
                              const SizedBox(height: 10),
                              const _ChartPlaceholder(height: 160),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _MiniTotalTile(
                                      label: 'Tổng Thu',
                                      value: '$income Vnd',
                                      icon: Icons.trending_up,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _MiniTotalTile(
                                      label: 'Tổng Chi',
                                      value: '$expense Vnd',
                                      icon: Icons.trending_down,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const _PiePlaceholder(height: 170),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Năm $_year',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String title;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const _ReportHeader({
    required this.title,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _HeaderMetric(label: leftLabel, value: leftValue),
                ),
                Container(
                  height: 34,
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: _HeaderMetric(label: rightLabel, value: rightValue),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.check_box_outlined,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Tổng hợp thu/chi theo năm',
                  style: TextStyle(color: Colors.white.withOpacity(0.95)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _WhitePanel extends StatelessWidget {
  final Widget child;
  const _WhitePanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      child: child,
    );
  }
}

class _PillTabBar extends StatelessWidget {
  const _PillTabBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(0.08)),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: scheme.primary.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: Colors.black87,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800),
        tabs: const [
          Tab(text: 'Ngày'),
          Tab(text: 'Tuần'),
          Tab(text: 'Tháng'),
          Tab(text: 'Năm'),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
      ),
    );
  }
}

class _ChartPlaceholder extends StatelessWidget {
  final double height;
  const _ChartPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Chart (Task sau)',
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PiePlaceholder extends StatelessWidget {
  final double height;
  const _PiePlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12.withOpacity(0.06)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Pie (Task sau)',
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MiniTotalTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniTotalTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}