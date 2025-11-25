import 'package:flutter/material.dart';

import 'expense_category.dart';

class ExpenseFilter {
  const ExpenseFilter({this.category, this.startDate});

  final ExpenseCategory? category;
  final DateTime? startDate;

  Map<String, String> toQueryParams() {
    final map = <String, String>{};
    if (category != null) map['category'] = category!.name;
    if (startDate != null) {
      map['startDate'] = startDate!.toUtc().toIso8601String();
    }
    return map;
  }

  bool get isEmpty => category == null && startDate == null;
}
