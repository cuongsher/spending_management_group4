import 'package:flutter_test/flutter_test.dart';

import 'package:spending_management_group4/main.dart';

void main() {
  testWidgets('launch screen is shown on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const MoneyLoopApp());

    expect(find.text('MoneyLoop'), findsOneWidget);
  });
}
