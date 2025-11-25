import 'dart:convert';

import '../models/user.dart';
import '../services/api_exception.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  AuthRepository(this._service);

  final AuthApiService _service;

  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _service.signup(name: name, email: email, password: password);
  }

  Future<User> login({
    required String email,
    required String password,
  }) {
    return _service.login(email: email, password: password);
  }

  String describeError(Object error) {
    if (error is ApiException) {
      try {
        final decoded = jsonDecode(error.body) as Map<String, dynamic>;
        return decoded['message'] as String? ?? 'Request failed';
      } catch (_) {
        return 'Request failed (${error.statusCode})';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}

