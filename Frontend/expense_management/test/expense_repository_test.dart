import 'package:expense_management/data/models/expense.dart';
import 'package:expense_management/data/models/expense_category.dart';
import 'package:expense_management/data/repositories/expense_repository.dart';
import 'package:expense_management/data/services/mock_expense_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseRepository', () {
    late ExpenseRepository repository;

    setUp(() {
      repository = ExpenseRepository(MockExpenseService());
    });

    test('loads initial expenses', () async {
      final expenses = await repository.getExpenses();
      expect(expenses, isNotEmpty);
    });

    test('adds expenses', () async {
      final created = await repository.addExpense(
        Expense(
          amount: 250,
          description: 'Client visit snacks',
          date: DateTime(2024, 9, 2),
          category: ExpenseCategory.food,
        ),
      );

      expect(created.id, isNotNull);
      final expenses = await repository.getExpenses();
      expect(expenses.any((item) => item.id == created.id), isTrue);
    });

    test('updates expenses', () async {
      final existing = (await repository.getExpenses()).first;
      final updated = await repository.updateExpense(
        existing.copyWith(description: 'Updated label'),
      );

      expect(updated.description, 'Updated label');
    });

    test('deletes expenses', () async {
      final first = (await repository.getExpenses()).first;
      await repository.deleteExpense(first.id!);
      final all = await repository.getExpenses();
      expect(all.any((item) => item.id == first.id), isFalse);
    });
  });
}

