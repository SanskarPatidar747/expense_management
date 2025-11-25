import 'package:flutter/material.dart';

enum ExpenseCategory {
  food(Icons.restaurant, 'Food & Dining'),
  transport(Icons.directions_bus, 'Transport'),
  utilities(Icons.bolt, 'Utilities'),
  entertainment(Icons.movie, 'Entertainment'),
  shopping(Icons.shopping_bag, 'Shopping'),
  travel(Icons.flight_takeoff, 'Travel'),
  other(Icons.more_horiz, 'Other');

  const ExpenseCategory(this.icon, this.label);

  final IconData icon;
  final String label;

  static ExpenseCategory fromValue(String? value) {
    if (value == null) return ExpenseCategory.other;
    return ExpenseCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}
