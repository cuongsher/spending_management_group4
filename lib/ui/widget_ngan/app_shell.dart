import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/provider_ngan/transactionProvider.dart';
import '../screen_cuongnd/CustomPage.dart';
import '../screen_cuongnd/homePage.dart';
import '../screen_ngan/screen_add_transaction.dart';
import '../screen_ngan/screen_history.dart';
import '../screen_ngan/screen_report.dart';



class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _index = 1;

  void _onTabChanged(int i) {
    setState(() => _index = i);
  }

  static final _tabs = <Widget>[
    MyHomePage(title: 'Home'),
    ReportScreen(),
    HistoryScreen(),
    CustomPage(),
    _PlaceholderScreen(title: 'Cá nhân'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onTabChanged,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Báo cáo'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Lịch sử'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Tùy chỉnh'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Cá nhân'),
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

// Tab Tùy Chỉnh = màn hình thêm ghi chép, reset lại sau khi lưu
class _AddTransactionTab extends ConsumerStatefulWidget {
  const _AddTransactionTab();

  @override
  ConsumerState<_AddTransactionTab> createState() => _AddTransactionTabState();
}

class _AddTransactionTabState extends ConsumerState<_AddTransactionTab> {
  Key _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final dbAsync = ref.watch(databaseProvider);
    return dbAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Lỗi: $e')),
      ),
      data: (_) => KeyedSubtree(
        key: _key,
        child: AddTransactionScreen(
          onSaved: () => setState(() => _key = UniqueKey()),
        ),
      ),
    );
  }
}
