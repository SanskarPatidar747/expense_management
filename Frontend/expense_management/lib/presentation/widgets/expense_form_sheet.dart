import 'package:flutter/material.dart';

import '../../core/utils/error_mapper.dart';
import '../../data/models/expense.dart';
import '../../data/models/expense_category.dart';

class ExpenseFormSheet extends StatefulWidget {
  const ExpenseFormSheet({
    super.key,
    this.initialExpense,
    required this.onSubmit,
  });

  final Expense? initialExpense;
  final Future<void> Function(Expense expense) onSubmit;

  static Future<void> show(
    BuildContext context, {
    Expense? expense,
    required Future<void> Function(Expense expense) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExpenseFormSheet(initialExpense: expense, onSubmit: onSubmit),
      ),
    );
  }

  @override
  State<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends State<ExpenseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  ExpenseCategory? _selectedCategory;
  bool _isSaving = false;
  String? _formError;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialExpense;
    _amountController = TextEditingController(
      text: initial?.amount.toStringAsFixed(2) ?? '',
    );
    _descriptionController = TextEditingController(
      text: initial?.description ?? '',
    );
    _selectedDate = initial?.date ?? DateTime.now();
    _selectedCategory = initial?.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialExpense != null;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Edit expense' : 'New expense',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Amount is required';
                }
                final parsed = double.tryParse(value);
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ExpenseCategory>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: ExpenseCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon, size: 18),
                          const SizedBox(width: 6),
                          Text(category.label),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value),
              validator: (value) =>
                  value == null ? 'Please choose a category' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                if (value.trim().length < 3) {
                  return 'Add more detail';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.event),
              label: Text(
                MaterialLocalizations.of(
                  context,
                ).formatMediumDate(_selectedDate),
              ),
            ),
            const SizedBox(height: 20),
            if (_formError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _formError!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSaving ? null : _handleSubmit,
                child: _isSaving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Save changes' : 'Create expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final context = this.context;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
      _formError = null;
    });
    final amount = double.parse(_amountController.text);
    final expense = Expense(
      id: widget.initialExpense?.id,
      amount: amount,
      description: _descriptionController.text.trim(),
      date: _selectedDate,
      category: _selectedCategory!,
    );
    try {
      await widget.onSubmit(expense);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _formError = ErrorMapper.message(error);
      });
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
