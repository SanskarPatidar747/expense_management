import 'package:flutter/material.dart';

import '../../core/utils/date_formatter.dart';
import '../../data/models/expense_category.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({
    super.key,
    required this.total,
    required this.categoryTotals,
  });

  final double total;
  final Map<ExpenseCategory, double> categoryTotals;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                colors.primaryContainer,
                colors.primaryContainer.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total spend',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: colors.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${total.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Updated ${DateFormatter.format(DateTime.now())}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colors.onPrimaryContainer.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.onPrimaryContainer.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pie_chart,
                    size: 32,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ExpenseCategory.values.map((category) {
            final categoryTotal = categoryTotals[category] ?? 0;
            return _CategoryCard(
              category: category,
              amount: categoryTotal,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.amount,
  });

  final ExpenseCategory category;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 160,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colors.surface,
          border: Border.all(
            color: colors.primary.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(category.icon, color: colors.primary, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                category.label,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '₹${amount.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

