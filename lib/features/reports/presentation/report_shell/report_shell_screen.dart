import 'package:flutter/material.dart';

import '../daily/report_daily_screen.dart';
import '../monthly/report_monthly_screen.dart';
import '../weekly/report_weekly_screen.dart';
import '../yearly/report_yearly_screen.dart';

class ReportShellScreen extends StatelessWidget {
  const ReportShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            ReportDailyScreen(),
            ReportWeeklyScreen(),
            ReportMonthlyScreen(),
            ReportYearlyScreen(),
          ],
        ),
      ),
    );
  }
}
