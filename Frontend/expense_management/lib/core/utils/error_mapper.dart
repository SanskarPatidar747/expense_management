import 'dart:convert';

import '../../data/services/api_exception.dart';

class ErrorMapper {
  const ErrorMapper._();

  static String message(Object error) {
    if (error is ApiException) {
      return _messageFromBody(error.body) ??
          'Request failed (${error.statusCode})';
    }
    return 'Something went wrong. Please try again.';
  }

  static String? _messageFromBody(String body) {
    try {
      final decoded = body.isNotEmpty ? jsonDecode(body) : null;
      if (decoded is Map<String, dynamic>) {
        return decoded['message'] as String? ??
            decoded['error'] as String? ??
            decoded['detail'] as String?;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

