import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/report/controller_report_monthly.dart';
import '../../provider/provider_ngan/transactionProvider.dart';

class ReportMonthlyScreen extends ConsumerStatefulWidget {
  const ReportMonthlyScreen({super.key});

  @override
  ConsumerState<ReportMonthlyScreen> createState() => _ReportMonthlyScreenState();
}

// 2. Đổi thành ConsumerState
class _ReportMonthlyScreenState extends ConsumerState<ReportMonthlyScreen> {
  late final ReportMonthlyController _controller;

  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    // 3. Lấy repository_cuongnm từ provider thay vì AppScope
    final repo = ref.read(transactionRepoProvider);
    _controller = ReportMonthlyController(repo);
    _controller.loadMonth(year: _year, month: _month);
  }

  void _prevMonth() {
    setState(() {
      _month -= 1;
      if (_month == 0) {
        _month = 12;
        _year -= 1;
      }
    });
    _controller.loadMonth(year: _year, month: _month);
  }

  void _nextMonth() {
    setState(() {
      _month += 1;
      if (_month == 13) {
        _month = 1;
        _year += 1;
      }
    });
    _controller.loadMonth(year: _year, month: _month);
  }

  @override
  Widget build(BuildContext context) {
    // 1. Cần DefaultTabController để TabBar hoạt động
    return DefaultTabController(
      length: 4,
      initialIndex: 2, // Mặc định là Tab 'Tháng'
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, __) {
          if (_controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final summary = _controller.summary;
          final income = summary?.totalIncome ?? 0;
          final expense = summary?.totalExpense ?? 0;
          final balance = summary?.balance ?? 0;

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FB), // Màu nền nhẹ cho ứng dụng
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
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 14, bottom: 80),
                      child: Column(
                        children: [
                          _WhitePanel(
                            child: Column(
                              children: [
                                const _PillTabBar(),
                                const SizedBox(height: 14),

                                // Bộ chọn tháng
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _CircleIconButton(
                                      icon: Icons.chevron_left,
                                      onPressed: _prevMonth,
                                    ),
                                    Text(
                                      'Tháng $_month/$_year',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      ),
                                    ),
                                    _CircleIconButton(
                                      icon: Icons.chevron_right,
                                      onPressed: _nextMonth,
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
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _MiniTotalTile(
                                        label: 'Tổng Chi',
                                        value: '$expense Vnd',
                                        icon: Icons.trending_down,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                const _PiePlaceholder(height: 170),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Logic thêm nhanh giao dịch
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

// --- Các Widget bổ trợ để code sạch hơn ---

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.withOpacity(0.1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String title, leftLabel, leftValue, rightLabel, rightValue;

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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(color: Colors.white),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _HeaderMetric(label: leftLabel, value: leftValue)),
                Container(height: 30, width: 1, color: Colors.white24),
                Expanded(child: _HeaderMetric(label: rightLabel, value: rightValue)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String label, value;
  const _HeaderMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
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
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ],
        ),
        labelColor: scheme.primary,
        unselectedLabelColor: Colors.black54,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
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
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
      ),
    );
  }
}

// --- Placeholder Widgets cho các Task sau ---

class _ChartPlaceholder extends StatelessWidget {
  final double height;
  const _ChartPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: const Text('Chart (Task sau)', style: TextStyle(color: Colors.blueGrey)),
    );
  }
}

class _PiePlaceholder extends StatelessWidget {
  final double height;
  const _PiePlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
      ),
      alignment: Alignment.center,
      child: const Text('Pie (Task sau)', style: TextStyle(color: Colors.blueGrey)),
    );
  }
}

class _MiniTotalTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;

  const _MiniTotalTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }
}