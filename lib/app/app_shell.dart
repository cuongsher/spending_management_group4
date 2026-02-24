import 'package:flutter/material.dart';
import '../features/reports/presentation/report_shell/report_shell_screen.dart';
import '../features/transactions/presentation/history/history_screen.dart';


class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 1;

  late final _tabs = <Widget>[
    const _PlaceholderScreen(title: 'Home'),
    const ReportShellScreen(),
    const HistoryScreen(),
    const _PlaceholderScreen(title: 'Tùy chỉnh'),
    const _PlaceholderScreen(title: 'Cá nhân'),
    const _PlaceholderScreen(title: 'Thử thách'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Báo cáo'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Lịch sử'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Tùy chỉnh'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), label: 'Thử thách'),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Screen: $title')),
    );
  }
}
