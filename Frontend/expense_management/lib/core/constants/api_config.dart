import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  static final String baseUrl = _resolveBaseUrl();
  static const Duration requestTimeout = Duration(seconds: 20);

  static Uri expensesUri({Map<String, String>? query}) {
    return _buildUri('/expenses', query: query);
  }

  static Uri expenseById(String id) {
    return _buildUri('/expenses/$id');
  }

  static Uri authSignupUri() {
    return _buildUri('/auth/signup');
  }

  static Uri authLoginUri() {
    return _buildUri('/auth/login');
  }

  static String _resolveBaseUrl() {
    const override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override;
    }

    if (kIsWeb && Uri.base.hasAuthority) {
      final origin = Uri.base.origin;
      return '$origin/api';
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }

    return 'http://localhost:8080/api';
  }

  static Uri _buildUri(String path, {Map<String, String>? query}) {
    final normalizedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath');
    return query == null ? uri : uri.replace(queryParameters: query);
  }
}
