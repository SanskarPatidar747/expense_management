import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../models/expense.dart';
import '../models/expense_filter.dart';
import 'api_exception.dart';

abstract class ExpenseService {
  Future<List<Expense>> fetchExpenses({ExpenseFilter? filter});
  Future<Expense> createExpense(Expense expense);
  Future<Expense> updateExpense(Expense expense);
  Future<void> deleteExpense(String id);
}

class ExpenseApiService implements ExpenseService {
  ExpenseApiService({required this.userId, this.authToken, http.Client? client})
    : _client = client ?? http.Client();

  final String userId;
  final String? authToken;
  final http.Client _client;

  @override
  Future<List<Expense>> fetchExpenses({ExpenseFilter? filter}) async {
    final uri = ApiConfig.expensesUri(query: filter?.toQueryParams());
    final response = await _client
        .get(uri, headers: _baseHeaders)
        .timeout(ApiConfig.requestTimeout);
    _throwIfUnsuccessful(response);

    final decoded = json.decode(response.body) as List<dynamic>;
    return decoded.map((jsonItem) {
      return Expense.fromJson(jsonItem as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<Expense> createExpense(Expense expense) async {
    final response = await _client
        .post(
          ApiConfig.expensesUri(),
          body: json.encode(expense.toJson(includeId: false)),
          headers: _jsonHeaders,
        )
        .timeout(ApiConfig.requestTimeout);
    _throwIfUnsuccessful(response);
    return Expense.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    final response = await _client
        .put(
          ApiConfig.expenseById(expense.id!),
          body: json.encode(expense.toJson()),
          headers: _jsonHeaders,
        )
        .timeout(ApiConfig.requestTimeout);
    _throwIfUnsuccessful(response);
    return Expense.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<void> deleteExpense(String id) async {
    final response = await _client
        .delete(ApiConfig.expenseById(id), headers: _baseHeaders)
        .timeout(ApiConfig.requestTimeout);
    _throwIfUnsuccessful(response);
  }

  void _throwIfUnsuccessful(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }

  Map<String, String> get _baseHeaders {
    return {
      'X-USER-ID': userId,
      if (authToken != null && authToken!.isNotEmpty)
        'Authorization': 'Bearer $authToken',
    };
  }

  Map<String, String> get _jsonHeaders {
    return {..._baseHeaders, 'Content-Type': 'application/json'};
  }
}
