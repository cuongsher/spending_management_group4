import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/database/models/BudgetModel.dart';
import '../../data/repository/home_repository.dart';
import '../../router/app_router.dart';
import '../provider/home_provider.dart';
import '../widgets/app_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color primary = Color(0xFF16C8A0);
  static const Color lightBg = Color(0xFFEAF6EE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<HomeProvider>().loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final dashboard = provider.dashboard;

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
                body: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : dashboard == null
                    ? Center(
                        child: Text(
                          provider.errorMessage ?? 'Không có dữ liệu',
                        ),
                      )
                    : Column(
                        children: [
                          _buildHeader(context, dashboard),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                12,
                              ),
                              decoration: const BoxDecoration(
                                color: lightBg,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tình Hình Thu Chi',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _sectionCard(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: SizedBox(
                                              height: 96,
                                              child: _MiniBarChart(),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 90,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _legendRow(
                                                  'Tổng Thu',
                                                  dashboard.totalIncome,
                                                  const Color(0xFF103D3D),
                                                ),
                                                const SizedBox(height: 8),
                                                _legendRow(
                                                  'Tổng Chi',
                                                  dashboard.totalExpense,
                                                  const Color(0xFF164BFF),
                                                ),
                                                const Divider(
                                                  color: Colors.white,
                                                ),
                                                Text(
                                                  'Chênh lệch\n${dashboard.balance.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color:
                                                        dashboard.balance >= 0
                                                        ? Colors.white
                                                        : Colors.red,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _sectionCard(
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            child: SizedBox(
                                              height: 110,
                                              child: _PiePlaceholder(),
                                            ),
                                          ),
                                          Container(
                                            width: 1,
                                            height: 90,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              children: dashboard.breakdown
                                                  .map(
                                                    (item) => Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 4,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .layers_rounded,
                                                            size: 18,
                                                            color: Color(
                                                              0xFF0F3D3D,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              item.name,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${item.percentage.round()} %',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    const Text(
                                      'Tổng Quan Lịch Sử',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _historySection(dashboard.historyItems),
                                    const SizedBox(height: 18),
                                    const Text(
                                      'Hạn Mức Chi Tiêu',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    _budgetSection(context, dashboard.budgets),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRouter.addBudget,
                                          );
                                        },
                                        child: Container(
                                          width: 72,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color(0xFF143C3C),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Color(0xFF143C3C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    const AppBottomNav(
                                      currentRoute: AppRouter.home,
                                    ),
                                  ],
                                ),
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

  Widget _buildHeader(BuildContext context, HomeDashboardData dashboard) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xin chào, ${dashboard.user?.fullName ?? ''}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF103B3B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Chào buổi sáng',
                      style: TextStyle(color: Color(0xFF0F3C3C)),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.notifications);
                },
                child: Container(
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
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _summaryTile('Tổng Dư', dashboard.balance, Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryTile(
                  'Tổng Chi',
                  dashboard.totalExpense,
                  const Color(0xFF164BFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: LinearProgressIndicator(
              minHeight: 18,
              value: dashboard.totalIncome == 0
                  ? 0
                  : (dashboard.totalExpense / dashboard.totalIncome).clamp(
                      0.0,
                      1.0,
                    ),
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF153C3C)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile(String title, double amount, Color amountColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} VND',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: amountColor,
          ),
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16C8A0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  Widget _legendRow(String label, double value, Color color) {
    return Row(
      children: [
        Icon(Icons.call_made_rounded, size: 18, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text(label)),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(fontWeight: FontWeight.w700, color: color),
        ),
      ],
    );
  }

  Widget _historySection(List<HomeHistoryItem> items) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8BC0FF),
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
            )
            .toList(),
      ),
    );
  }

  Widget _budgetSection(BuildContext context, List<BudgetModel> budgets) {
    final previewBudgets = budgets.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
      ),
      child: previewBudgets.isEmpty
          ? const Text('Chưa có hạn mức chi tiêu')
          : Column(
              children: previewBudgets
                  .map(
              (budget) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFF16C8A0),
                      child: Text(
                        '\$',
                        style: TextStyle(color: Color(0xFF103D3D)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        budget.budgetName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${budget.amount.toStringAsFixed(2)} VND',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFF164BFF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
                  .toList(),
            ),
    );
  }
}

class _MiniBarChart extends StatelessWidget {
  const _MiniBarChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BarChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _PiePlaceholder extends StatelessWidget {
  const _PiePlaceholder();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PiePainter(), child: const SizedBox.expand());
  }
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF103D3D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final baseY = size.height - 8;
    final heights = [20.0, 52.0, 32.0, 66.0, 24.0];
    for (var i = 0; i < heights.length; i++) {
      final dx = 16.0 + (i * 18.0);
      canvas.drawLine(Offset(dx, baseY), Offset(dx, baseY - heights[i]), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.28,
    );
    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color(0xFF103D3D);
    canvas.drawArc(rect, 0, 5.2, false, outline);
    final fill = Paint()..color = const Color(0xFF0F3D3D);
    canvas.drawArc(rect, -1.57, 1.57, true, fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
