import '../models/expense.dart';
import '../models/expense_filter.dart';
import '../services/expense_api_service.dart';

class ExpenseRepository {
  ExpenseRepository(this._service);

  final ExpenseService _service;

  Future<List<Expense>> getExpenses({ExpenseFilter? filter}) {
    return _service.fetchExpenses(filter: filter);
  }

  Future<Expense> addExpense(Expense expense) {
    return _service.createExpense(expense);
  }

  Future<Expense> updateExpense(Expense expense) {
    if (expense.id == null) {
      throw ArgumentError('Expense id is required for updates');
    }
    return _service.updateExpense(expense);
  }

  Future<void> deleteExpense(String id) {
    return _service.deleteExpense(id);
  }
}
