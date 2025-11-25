import 'package:expense_management/data/models/user.dart';
import 'package:expense_management/data/repositories/expense_repository.dart';
import 'package:expense_management/data/services/mock_expense_service.dart';
import 'package:expense_management/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _waitForText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  const maxTries = 10;
  for (var i = 0; i < maxTries; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Text "$text" not found after waiting');
}

void main() {
  testWidgets('renders dashboard with seeded expenses', (tester) async {
    final repository = ExpenseRepository(MockExpenseService());
    const user = User(
      id: 'test',
      name: 'Test User',
      email: 'test@example.com',
      token: 'token',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardScreen(
          repository: repository,
          user: user,
          onLogout: () {},
        ),
      ),
    );

    await _waitForText(tester, 'Expense Manager');
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await _waitForText(tester, 'Team lunch');

    expect(find.text('Expense Manager'), findsOneWidget);
    expect(find.text('Team lunch'), findsOneWidget);
  });
}
