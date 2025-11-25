import 'expense_category.dart';

class Expense {
  const Expense({
    this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.category,
  });

  final String? id;
  final double amount;
  final String description;
  final DateTime date;
  final ExpenseCategory category;

  Expense copyWith({
    String? id,
    double? amount,
    String? description,
    DateTime? date,
    ExpenseCategory? category,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id']?.toString(),
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      category: ExpenseCategory.fromValue(json['category'] as String?),
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    return {
      if (includeId && id != null) 'id': id,
      'amount': amount,
      'description': description,
      'date': date.toUtc().toIso8601String(),
      'category': category.name,
    };
  }
}

