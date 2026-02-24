import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:quan_li_chi_tieu/app/app_shell.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppShell(),
      ),
    );

    // Chỉ cần verify app render được
    expect(find.byType(AppShell), findsOneWidget);
  });
}