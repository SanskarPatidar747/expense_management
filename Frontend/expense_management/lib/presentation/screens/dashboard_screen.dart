import 'package:flutter/material.dart';
import '../../core/utils/error_mapper.dart';
import '../../data/models/expense.dart';
import '../../data/models/expense_category.dart';
import '../../data/models/expense_filter.dart';
import '../../data/models/user.dart';
import '../../data/repositories/expense_repository.dart';
import '../widgets/app_error_view.dart';
import '../widgets/dashboard_summary.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_filter_bar.dart';
import '../widgets/expense_form_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.repository,
    required this.user,
    required this.onLogout,
  });

  final ExpenseRepository repository;
  final User user;
  final VoidCallback onLogout;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Expense> _expenses = const [];
  ExpenseFilter _filter = const ExpenseFilter();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Expense Manager'),
            Text(
              'Hi, ${widget.user.name}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loadExpenses,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Log out',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddPressed,
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _expenses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _expenses.isEmpty) {
      return AppErrorView(message: _error!, onRetry: _loadExpenses);
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const maxContentWidth = 900.0;
          final isWide = constraints.maxWidth > maxContentWidth;
          final horizontalPadding = isWide
              ? (constraints.maxWidth - maxContentWidth) / 2
              : 16.0;

          return RefreshIndicator(
            onRefresh: _loadExpenses,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                100,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                DashboardSummary(
                  total: _totalSpent,
                  categoryTotals: _spendByCategory,
                ),
                const SizedBox(height: 16),
                ExpenseFilterBar(
                  filter: _filter,
                  onCategoryChanged: _updateCategoryFilter,
                  onDateChanged: _updateDateFilter,
                  onClearFilters: _clearFilters,
                ),
                const SizedBox(height: 16),
                if (_expenses.isEmpty)
                  const _EmptyState()
                else
                  ..._expenses.map(
                    (expense) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ExpenseCard(
                        expense: expense,
                        onEdit: () => _onEditExpense(expense),
                        onDelete: () => _confirmDelete(expense),
                      ),
                    ),
                  ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final items = await widget.repository.getExpenses(filter: _filter);
      if (!mounted) return;
      setState(() {
        _expenses = items;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = ErrorMapper.message(error);
      });
      _showErrorSnack(error);
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onAddPressed() {
    return ExpenseFormSheet.show(
      context,
      onSubmit: (expense) async {
        final created = await widget.repository.addExpense(expense);
        if (!mounted) return;
        setState(() {
          _expenses = [..._expenses, created];
        });
        _showSnack('Expense added');
      },
    );
  }

  Future<void> _onEditExpense(Expense expense) {
    return ExpenseFormSheet.show(
      context,
      expense: expense,
      onSubmit: (updatedExpense) async {
        final saved = await widget.repository.updateExpense(updatedExpense);
        if (!mounted) return;
        setState(() {
          _expenses = _expenses
              .map((existing) => existing.id == saved.id ? saved : existing)
              .toList();
        });
        _showSnack('Expense updated');
      },
    );
  }

  Future<void> _confirmDelete(Expense expense) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense'),
        content: Text(
          'Are you sure you want to remove "${expense.description}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true && expense.id != null) {
      try {
        await widget.repository.deleteExpense(expense.id!);
        if (!mounted) return;
        setState(() {
          _expenses = _expenses.where((item) => item.id != expense.id).toList();
        });
        _showSnack('Expense deleted');
      } catch (error) {
        if (!mounted) return;
        _showErrorSnack(error);
      }
    }
  }

  void _updateCategoryFilter(ExpenseCategory? category) {
    setState(() {
      _filter = ExpenseFilter(category: category, startDate: _filter.startDate);
    });
    _loadExpenses();
  }

  void _updateDateFilter(DateTime? date) {
    setState(() {
      _filter = ExpenseFilter(category: _filter.category, startDate: date);
    });
    _loadExpenses();
  }

  void _clearFilters() {
    setState(() {
      _filter = const ExpenseFilter();
    });
    _loadExpenses();
  }

  double get _totalSpent =>
      _expenses.fold(0, (sum, expense) => sum + expense.amount);

  Map<ExpenseCategory, double> get _spendByCategory {
    final totals = <ExpenseCategory, double>{};
    for (final category in ExpenseCategory.values) {
      totals[category] = 0;
    }
    for (final expense in _expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorSnack(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(ErrorMapper.message(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Add expense" to get started.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
