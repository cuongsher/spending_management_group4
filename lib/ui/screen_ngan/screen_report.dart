import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/report/controller_report_daily.dart';
import '../../controller/report/controller_report_weekly.dart';
import '../../controller/report/controller_report_monthly.dart';
import '../../controller/report/controller_report_yearly.dart';
import '../../data/database/model1/report.dart';
import '../../provider/provider_ngan/transactionProvider.dart';

// ─── Main Screen ─────────────────────────────────────────────────────────────

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Controllers
  late ReportDailyController _dailyCtrl;
  late ReportWeeklyController _weeklyCtrl;
  late ReportMonthlyController _monthlyCtrl;
  late ReportYearlyController _yearlyCtrl;

  // State cho từng tab
  DateTime _day = DateTime.now();
  DateTime _weekAnchor = DateTime.now();
  int _month = DateTime.now().month;
  int _monthYear = DateTime.now().year;
  int _year = DateTime.now().year;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _initControllers() {
    if (_initialized) return;
    _initialized = true;
    final repo = ref.read(transactionRepoProvider);
    _dailyCtrl = ReportDailyController(repo);
    _weeklyCtrl = ReportWeeklyController(repo);
    _monthlyCtrl = ReportMonthlyController(repo);
    _yearlyCtrl = ReportYearlyController(repo);

    _dailyCtrl.load(_day);
    _weeklyCtrl.loadWeek(_weekAnchor);
    _monthlyCtrl.loadMonth(year: _monthYear, month: _month);
    _yearlyCtrl.loadYear(_year);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    setState(() {}); // rebuild khi đổi tab
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  ReportSummary? get _currentSummary {
    switch (_tabController.index) {
      case 0: return _dailyCtrl.summary;
      case 1: return _weeklyCtrl.summary;
      case 2: return _monthlyCtrl.summary;
      case 3: return _yearlyCtrl.summary;
      default: return null;
    }
  }

  bool get _isLoading {
    switch (_tabController.index) {
      case 0: return _dailyCtrl.isLoading;
      case 1: return _weeklyCtrl.isLoading;
      case 2: return _monthlyCtrl.isLoading;
      case 3: return _yearlyCtrl.isLoading;
      default: return false;
    }
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  (DateTime, DateTime) _weekRange(DateTime any) {
    final d = DateTime(any.year, any.month, any.day);
    final mon = d.subtract(Duration(days: d.weekday - DateTime.monday));
    return (mon, mon.add(const Duration(days: 6)));
  }

  String _formatMoney(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
      buf.write(s[i]);
    }
    return '${buf.toString()} Vnd';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final dbAsync = ref.watch(databaseProvider);
    return dbAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Lỗi DB: $e'))),
      data: (_) {
        _initControllers();
        return ListenableBuilder(
          listenable: Listenable.merge([_dailyCtrl, _weeklyCtrl, _monthlyCtrl, _yearlyCtrl]),
          builder: (context, _) {
            final summary = _currentSummary;
            final income = summary?.totalIncome ?? 0;
            final expense = summary?.totalExpense ?? 0;
            final balance = summary?.balance ?? 0;

            return Scaffold(
              backgroundColor: const Color(0xFFF2F4F7),
              body: Column(
                children: [
                  _ReportHeader(
                    tabController: _tabController,
                    income: income,
                    expense: expense,
                    balance: balance,
                    formatMoney: _formatMoney,
                  ),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
                      child: _ReportCard(
                        tabController: _tabController,
                        day: _day,
                        onPrevDay: () {
                          setState(() => _day = _day.subtract(const Duration(days: 1)));
                          _dailyCtrl.load(_day);
                        },
                        onNextDay: () {
                          setState(() => _day = _day.add(const Duration(days: 1)));
                          _dailyCtrl.load(_day);
                        },
                        weekAnchor: _weekAnchor,
                        weekRange: _weekRange(_weekAnchor),
                        onPrevWeek: () {
                          setState(() => _weekAnchor = _weekAnchor.subtract(const Duration(days: 7)));
                          _weeklyCtrl.loadWeek(_weekAnchor);
                        },
                        onNextWeek: () {
                          setState(() => _weekAnchor = _weekAnchor.add(const Duration(days: 7)));
                          _weeklyCtrl.loadWeek(_weekAnchor);
                        },
                        month: _month,
                        monthYear: _monthYear,
                        onPrevMonth: () {
                          setState(() {
                            _month--;
                            if (_month == 0) { _month = 12; _monthYear--; }
                          });
                          _monthlyCtrl.loadMonth(year: _monthYear, month: _month);
                        },
                        onNextMonth: () {
                          setState(() {
                            _month++;
                            if (_month == 13) { _month = 1; _monthYear++; }
                          });
                          _monthlyCtrl.loadMonth(year: _monthYear, month: _month);
                        },
                        year: _year,
                        onPrevYear: () {
                          setState(() => _year--);
                          _yearlyCtrl.loadYear(_year);
                        },
                        onNextYear: () {
                          setState(() => _year++);
                          _yearlyCtrl.loadYear(_year);
                        },
                        income: income,
                        expense: expense,
                        formatMoney: _formatMoney,
                        fmt: _fmt,
                        barEntries: summary?.barEntries ?? [],
                        categoryEntries: summary?.categoryEntries ?? [],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.of(context).pushNamed('/add-transaction');
                  if (result == 'created') {
                    _dailyCtrl.load(_day);
                    _weeklyCtrl.loadWeek(_weekAnchor);
                    _monthlyCtrl.loadMonth(year: _monthYear, month: _month);
                    _yearlyCtrl.loadYear(_year);
                  }
                },
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          },
        );
      },
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ReportHeader extends StatelessWidget {
  final TabController tabController;
  final int income, expense, balance;
  final String Function(int) formatMoney;

  const _ReportHeader({
    required this.tabController,
    required this.income,
    required this.expense,
    required this.balance,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Báo Cáo',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Tổng Thu', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(formatMoney(income),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                ),
                Container(height: 36, width: 1, color: Colors.white24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Tổng Chi', style: TextStyle(color: Colors.white70, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text('-${formatMoney(expense)}',
                          style: const TextStyle(color: Color(0xFFFFD6D6), fontWeight: FontWeight.w900, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (income + expense) == 0 ? 0 : expense / (income + expense),
                minHeight: 8,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.check_box_outlined, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${((income + expense) == 0 ? 0 : (expense / (income + expense) * 100)).toStringAsFixed(0)}% Tổng Đã Chi',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Text(
                  formatMoney(income + expense),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card chứa TabBar + nội dung ─────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  final TabController tabController;
  // Daily
  final DateTime day;
  final VoidCallback onPrevDay, onNextDay;
  // Weekly
  final DateTime weekAnchor;
  final (DateTime, DateTime) weekRange;
  final VoidCallback onPrevWeek, onNextWeek;
  // Monthly
  final int month, monthYear;
  final VoidCallback onPrevMonth, onNextMonth;
  // Yearly
  final int year;
  final VoidCallback onPrevYear, onNextYear;
  // Shared
  final int income, expense;
  final String Function(int) formatMoney;
  final String Function(DateTime) fmt;
  final List<BarEntry> barEntries;
  final List<CategoryEntry> categoryEntries;

  const _ReportCard({
    required this.tabController,
    required this.day, required this.onPrevDay, required this.onNextDay,
    required this.weekAnchor, required this.weekRange, required this.onPrevWeek, required this.onNextWeek,
    required this.month, required this.monthYear, required this.onPrevMonth, required this.onNextMonth,
    required this.year, required this.onPrevYear, required this.onNextYear,
    required this.income, required this.expense,
    required this.formatMoney, required this.fmt,
    required this.barEntries, required this.categoryEntries,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Pill TabBar
          Container(
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
              tabs: const [Tab(text: 'Ngày'), Tab(text: 'Tuần'), Tab(text: 'Tháng'), Tab(text: 'Năm')],
            ),
          ),
          const SizedBox(height: 16),
          // Period selector
          _PeriodSelector(
            tabController: tabController,
            day: day, onPrevDay: onPrevDay, onNextDay: onNextDay,
            weekRange: weekRange, onPrevWeek: onPrevWeek, onNextWeek: onNextWeek,
            month: month, monthYear: monthYear, onPrevMonth: onPrevMonth, onNextMonth: onNextMonth,
            year: year, onPrevYear: onPrevYear, onNextYear: onNextYear,
            fmt: fmt,
          ),
          const SizedBox(height: 14),
          // Chart section
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Text('Thu Nhập & Chi Tiêu',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const Spacer(),
                _SmallIconBtn(icon: Icons.bar_chart, onTap: () {}),
                const SizedBox(width: 6),
                _SmallIconBtn(icon: Icons.pie_chart_outline, onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _BarChartWidget(barEntries: barEntries),
          const SizedBox(height: 16),
          // Tổng thu / chi
          Row(
            children: [
              Expanded(child: _TotalTile(label: 'Tổng Thu', value: formatMoney(income), icon: Icons.arrow_circle_up_outlined, color: Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _TotalTile(label: 'Tổng Chi', value: formatMoney(expense), icon: Icons.arrow_circle_down_outlined, color: const Color(0xFF1565C0))),
            ],
          ),
          const SizedBox(height: 16),
          _PieChartWidget(income: income, expense: expense, categoryEntries: categoryEntries),
        ],
      ),
    );
  }
}

// ─── Period Selector ─────────────────────────────────────────────────────────

class _PeriodSelector extends StatelessWidget {
  final TabController tabController;
  final DateTime day;
  final VoidCallback onPrevDay, onNextDay;
  final (DateTime, DateTime) weekRange;
  final VoidCallback onPrevWeek, onNextWeek;
  final int month, monthYear;
  final VoidCallback onPrevMonth, onNextMonth;
  final int year;
  final VoidCallback onPrevYear, onNextYear;
  final String Function(DateTime) fmt;

  const _PeriodSelector({
    required this.tabController,
    required this.day, required this.onPrevDay, required this.onNextDay,
    required this.weekRange, required this.onPrevWeek, required this.onNextWeek,
    required this.month, required this.monthYear, required this.onPrevMonth, required this.onNextMonth,
    required this.year, required this.onPrevYear, required this.onNextYear,
    required this.fmt,
  });

  String get _label {
    switch (tabController.index) {
      case 0: return fmt(day);
      case 1: return '${fmt(weekRange.$1)} - ${fmt(weekRange.$2)}';
      case 2: return 'Tháng $month/$monthYear';
      case 3: return 'Năm $year';
      default: return '';
    }
  }

  VoidCallback get _onPrev {
    switch (tabController.index) {
      case 0: return onPrevDay;
      case 1: return onPrevWeek;
      case 2: return onPrevMonth;
      case 3: return onPrevYear;
      default: return () {};
    }
  }

  VoidCallback get _onNext {
    switch (tabController.index) {
      case 0: return onNextDay;
      case 1: return onNextWeek;
      case 2: return onNextMonth;
      case 3: return onNextYear;
      default: return () {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleBtn(icon: Icons.chevron_left, onTap: _onPrev),
          Text(_label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          _CircleBtn(icon: Icons.chevron_right, onTap: _onNext),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.withOpacity(0.12)),
        child: Icon(icon, size: 20, color: Colors.black54),
      ),
    );
  }
}

class _SmallIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmallIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: scheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: scheme.primary),
      ),
    );
  }
}

// ─── Bar Chart (data thật) ────────────────────────────────────────────────────

class _BarChartWidget extends StatelessWidget {
  final List<BarEntry> barEntries;
  const _BarChartWidget({required this.barEntries});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (barEntries.isEmpty) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Text('Chưa có dữ liệu', style: TextStyle(color: Colors.black38)),
      );
    }

    final maxVal = barEntries
        .map((e) => e.income > e.expense ? e.income : e.expense)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      height: 160,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: barEntries.map((e) {
                final incRatio = maxVal == 0 ? 0.0 : e.income / maxVal;
                final expRatio = maxVal == 0 ? 0.0 : e.expense / maxVal;
                return _BarGroup(
                  incomeRatio: incRatio.clamp(0.02, 1.0),
                  expenseRatio: expRatio.clamp(0.0, 1.0),
                  scheme: scheme,
                  hasData: e.income > 0 || e.expense > 0,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: barEntries.map((e) => SizedBox(
              width: 36,
              child: Text(e.label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 9, color: Colors.black45)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _BarGroup extends StatelessWidget {
  final double incomeRatio, expenseRatio;
  final ColorScheme scheme;
  final bool hasData;
  const _BarGroup({required this.incomeRatio, required this.expenseRatio, required this.scheme, required this.hasData});

  @override
  Widget build(BuildContext context) {
    const maxH = 100.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 10, height: maxH * incomeRatio,
          decoration: BoxDecoration(
            color: hasData ? scheme.primary : scheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 2),
        Container(
          width: 10, height: maxH * expenseRatio,
          decoration: BoxDecoration(
            color: hasData ? const Color(0xFF1565C0) : const Color(0xFF1565C0).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

// ─── Total Tile ───────────────────────────────────────────────────────────────

class _TotalTile extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _TotalTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── Pie Chart (cân bằng Thu / Chi) ──────────────────────────────────────────

class _PieChartWidget extends StatelessWidget {
  final int income, expense;
  final List<CategoryEntry> categoryEntries;
  const _PieChartWidget({required this.income, required this.expense, required this.categoryEntries});

  String _fmt(int v) {
    final s = v.toString();
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
    final total = income + expense;

    if (total == 0) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: const Text('Chưa có dữ liệu', style: TextStyle(color: Colors.black38)),
      );
    }

    final incomeRatio = income / total;
    final expenseRatio = expense / total;
    final incomePct = (incomeRatio * 100).round();
    final expensePct = (expenseRatio * 100).round();

    return Column(
      children: [
        // Labels trên
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_fmt(income),
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: scheme.primary)),
            Text(_fmt(expense),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1565C0))),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CustomPaint(
            painter: _BalancePiePainter(incomeRatio: incomeRatio, expenseRatio: expenseRatio),
            child: Align(
              alignment: const Alignment(0, 0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$incomePct% / $expensePct%',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: scheme.primary)),
                  const Text('Thu / Chi', style: TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LegendDot(color: scheme.primary, label: 'Thu nhập'),
            const SizedBox(width: 16),
            const _LegendDot(color: Color(0xFF1565C0), label: 'Chi tiêu'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
}

class _BalancePiePainter extends CustomPainter {
  final double incomeRatio;
  final double expenseRatio;
  const _BalancePiePainter({required this.incomeRatio, required this.expenseRatio});

  static const _incomeColor = Color(0xFF00C49A);
  static const _expenseColor = Color(0xFF1565C0);
  static const _pi = 3.14159265358979;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.95;   // tâm gần đáy để cung không bị cắt trên
    final r = (size.width * 0.44).clamp(0.0, cy - 4); // bán kính không vượt quá cy
    final strokeW = r * 0.36;

    // Nền xám
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      _pi, _pi, false, bgPaint,
    );

    // Nửa trái = Thu (từ π đến π + incomeRatio*π)
    final incomeSweep = _pi * incomeRatio;
    final incomePaint = Paint()
      ..color = _incomeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      _pi, incomeSweep, false, incomePaint,
    );

    // Nửa phải = Chi (từ 0 về phía trái, tức từ 2π - expenseRatio*π đến 2π)
    final expenseSweep = _pi * expenseRatio;
    final expensePaint = Paint()
      ..color = _expenseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      2 * _pi - expenseSweep, expenseSweep, false, expensePaint,
    );
  }

  @override
  bool shouldRepaint(_BalancePiePainter old) =>
      old.incomeRatio != incomeRatio || old.expenseRatio != expenseRatio;
}
