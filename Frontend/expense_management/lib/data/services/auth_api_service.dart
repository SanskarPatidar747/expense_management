import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_config.dart';
import '../models/user.dart';
import 'api_exception.dart';

class AuthApiService {
  AuthApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<User> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client
        .post(
          ApiConfig.authSignupUri(),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name.trim(),
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(ApiConfig.requestTimeout);

    _throwIfUnsuccessful(response);
    return _mapUser(response);
  }

  Future<User> login({required String email, required String password}) async {
    final response = await _client
        .post(
          ApiConfig.authLoginUri(),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email.trim(), 'password': password}),
        )
        .timeout(ApiConfig.requestTimeout);

    _throwIfUnsuccessful(response);
    return _mapUser(response);
  }

  User _mapUser(http.Response response) {
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return User.fromJson(decoded);
  }

  void _throwIfUnsuccessful(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, response.body);
  }
}
