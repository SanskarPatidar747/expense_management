import 'package:flutter/material.dart';

import '../../data/models/expense_category.dart';
import '../../data/models/expense_filter.dart';

class ExpenseFilterBar extends StatelessWidget {
  const ExpenseFilterBar({
    super.key,
    required this.filter,
    required this.onCategoryChanged,
    required this.onDateChanged,
    required this.onClearFilters,
  });

  final ExpenseFilter filter;
  final ValueChanged<ExpenseCategory?> onCategoryChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final categoryItems = [
      const DropdownMenuItem<ExpenseCategory?>(
        value: null,
        child: Text('All categories'),
      ),
      ...ExpenseCategory.values.map(
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
    ];

    final dateLabel = _dateLabel(filter, context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 600;
            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<ExpenseCategory?>(
                    value: filter.category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: categoryItems,
                    onChanged: onCategoryChanged,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.event),
                    label: Text(dateLabel),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.tonalIcon(
                      onPressed: filter.isEmpty ? null : onClearFilters,
                      icon: const Icon(Icons.filter_alt_off),
                      label: const Text('Clear'),
                    ),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ExpenseCategory?>(
                    value: filter.category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    items: categoryItems,
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.event),
                    label: Text(dateLabel),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.tonalIcon(
                  onPressed: filter.isEmpty ? null : onClearFilters,
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Clear'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: filter.startDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  String _dateLabel(ExpenseFilter filter, BuildContext context) {
    if (filter.startDate == null) return 'Select start date';
    final localizations = MaterialLocalizations.of(context);
    return localizations.formatMediumDate(filter.startDate!);
  }
}

