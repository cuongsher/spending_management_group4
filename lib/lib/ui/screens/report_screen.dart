import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repository/report_repository.dart';
import '../../router/app_router.dart';
import '../provider/report_provider.dart';
import '../widgets/app_primary_shell.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ReportProvider>().loadReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
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
            child: Text(provider.errorMessage ?? 'Không có dữ liệu báo cáo'),
          ),
        ),
      );
    }

    return AppPrimaryShell(
      currentRoute: AppRouter.report,
      header: _buildHeader(dashboard),
      showAddButton: true,
      onAddTap: () async {
        final created =
            await Navigator.pushNamed(context, AppRouter.addTransaction)
                as bool?;
        if (created == true && mounted) {
          await this.context.read<ReportProvider>().loadReport(
            period: provider.selectedPeriod,
          );
        }
      },
      body: SingleChildScrollView(
        child: Column(
          children: [
            _periodRow(context, provider.selectedPeriod),
            const SizedBox(height: 16),
            _chartCard(dashboard),
            const SizedBox(height: 18),
            _breakdownCard(dashboard),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ReportDashboardData dashboard) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Báo Cáo',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF103B3B),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _summaryTile(
                  'Tổng Dư',
                  dashboard.totalIncome - dashboard.totalExpense,
                  Colors.white,
                ),
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
              value: dashboard.progress,
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Color(0xFF153C3C)),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '30% tổng đã chi',
            style: TextStyle(color: Color(0xFF0F3C3C)),
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

  Widget _periodRow(BuildContext context, String selectedPeriod) {
    const items = [
      ('day', 'Ngày'),
      ('week', 'Tuần'),
      ('month', 'Tháng'),
      ('year', 'Năm'),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    context.read<ReportProvider>().loadReport(period: item.$1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selectedPeriod == item.$1
                        ? const Color(0xFF16C8A0)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF103D3D),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chartCard(ReportDashboardData dashboard) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thu Nhập & Chi Tiêu',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _ReportBarPainter(dashboard.bars),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _metricBlock(
                  'Tổng Thu',
                  dashboard.totalIncome,
                  const Color(0xFF16C8A0),
                ),
              ),
              Expanded(
                child: _metricBlock(
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

  Widget _metricBlock(String title, double amount, Color color) {
    return Column(
      children: [
        Icon(Icons.call_made_rounded, color: color),
        const SizedBox(height: 6),
        Text(title),
        Text(
          '${amount.toStringAsFixed(2)} VND',
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _breakdownCard(ReportDashboardData dashboard) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _BreakdownPiePainter(dashboard.breakdown),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: dashboard.breakdown
                .map(
                  (item) => Text(
                    '${item.name} ${item.percentage.round()}%',
                    style: const TextStyle(
                      color: Color(0xFF164BFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ReportBarPainter extends CustomPainter {
  _ReportBarPainter(this.items);

  final List<ReportBarItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = const Color(0xFFB7D5C6)
      ..strokeWidth = 1;
    final incomePaint = Paint()..color = const Color(0xFF16C8A0);
    final expensePaint = Paint()..color = const Color(0xFF164BFF);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i < 4; i++) {
      final y = size.height * (i + 1) / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), axisPaint);
    }

    if (items.isEmpty) return;
    final maxValue = items.fold<double>(
      1,
      (max, item) => math.max(max, math.max(item.income, item.expense)),
    );
    final groupWidth = size.width / items.length;

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final centerX = (groupWidth * i) + (groupWidth / 2);
      final incomeHeight = (item.income / maxValue) * (size.height - 36);
      final expenseHeight = (item.expense / maxValue) * (size.height - 36);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            centerX - 16,
            size.height - incomeHeight - 24,
            10,
            incomeHeight,
          ),
          const Radius.circular(8),
        ),
        incomePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            centerX + 2,
            size.height - expenseHeight - 24,
            10,
            expenseHeight,
          ),
          const Radius.circular(8),
        ),
        expensePaint,
      );

      textPainter.text = TextSpan(
        text: item.label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF103D3D)),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(centerX - (textPainter.width / 2), size.height - 18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReportBarPainter oldDelegate) =>
      oldDelegate.items != items;
}

class _BreakdownPiePainter extends CustomPainter {
  _BreakdownPiePainter(this.items);

  final List<ReportPieItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    if (items.isEmpty) return;

    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: math.min(size.width, size.height) * 0.32,
    );
    final colors = [
      const Color(0xFF1D6FFF),
      const Color(0xFF4D94FF),
      const Color(0xFF6EB0FF),
      const Color(0xFF95C8FF),
    ];

    var startAngle = -math.pi / 2;
    for (var i = 0; i < items.length; i++) {
      final sweepAngle = (items[i].percentage / 100) * (math.pi * 2);
      final paint = Paint()..color = colors[i % colors.length];
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _BreakdownPiePainter oldDelegate) =>
      oldDelegate.items != items;
}
