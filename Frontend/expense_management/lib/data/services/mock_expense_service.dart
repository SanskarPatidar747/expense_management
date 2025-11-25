import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/expense_filter.dart';
import 'expense_api_service.dart';

class MockExpenseService implements ExpenseService {
  MockExpenseService();

  final List<Expense> _store = [
    Expense(
      id: '1',
      amount: 560,
      description: 'Team lunch',
      date: DateTime(2024, 8, 10),
      category: ExpenseCategory.food,
    ),
    Expense(
      id: '2',
      amount: 120,
      description: 'Metro card top-up',
      date: DateTime(2024, 8, 11),
      category: ExpenseCategory.transport,
    ),
    Expense(
      id: '3',
      amount: 980,
      description: 'Electricity bill',
      date: DateTime(2024, 8, 8),
      category: ExpenseCategory.utilities,
    ),
  ];

  int _nextId = 4;

  @override
  Future<List<Expense>> fetchExpenses({ExpenseFilter? filter}) async {
    Iterable<Expense> results = _store;
    if (filter?.category != null) {
      results = results.where(
        (expense) => expense.category == filter!.category,
      );
    }
    if (filter?.startDate != null) {
      final start = filter!.startDate!;
      results = results.where(
        (expense) => !expense.date.isBefore(start),
      );
    }
    return results.toList(growable: false);
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    final created = expense.copyWith(id: '${_nextId++}');
    _store.add(created);
    return created;
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final index = _store.indexWhere((item) => item.id == expense.id);
    if (index != -1) {
      _store[index] = expense;
    }
    return expense;
  }

  @override
  Future<void> deleteExpense(String id) async {
    _store.removeWhere((expense) => expense.id == id);
  }
}
