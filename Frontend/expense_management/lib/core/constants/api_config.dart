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
    const directOverride = String.fromEnvironment('API_BASE_URL');
    if (directOverride.isNotEmpty) {
      return directOverride;
    }

    if (kIsWeb && Uri.base.hasAuthority) {
      final origin = Uri.base.origin;
      return '$origin/api';
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      return 'http://localhost:8080/api';
    }

    const hostedOverride = String.fromEnvironment('HOSTED_API_BASE_URL');
    if (hostedOverride.isNotEmpty) {
      return hostedOverride;
    }

    return 'https://expense-backend-g60e.onrender.com/api';
  }

  static Uri _buildUri(String path, {Map<String, String>? query}) {
    final normalizedBase =
        baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$normalizedBase$normalizedPath');
    return query == null ? uri : uri.replace(queryParameters: query);
  }
}
