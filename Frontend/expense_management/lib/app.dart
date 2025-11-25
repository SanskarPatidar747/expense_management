import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/models/user.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/expense_repository.dart';
import 'data/services/auth_api_service.dart';
import 'data/services/expense_api_service.dart';
import 'data/services/mock_expense_service.dart';
import 'presentation/screens/auth_screen.dart';
import 'presentation/screens/dashboard_screen.dart';

const bool _useMockServiceFlag = bool.fromEnvironment(
  'USE_MOCK_SERVICE',
  defaultValue: false,
);

class ExpenseApp extends StatefulWidget {
  const ExpenseApp({super.key, ExpenseRepository? repository})
    : _repositoryOverride = repository;

  final ExpenseRepository? _repositoryOverride;

  @override
  State<ExpenseApp> createState() => _ExpenseAppState();
}

class _ExpenseAppState extends State<ExpenseApp> {
  late final AuthRepository _authRepository;
  ExpenseRepository? _repository;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(AuthApiService());
    _repository = widget._repositoryOverride;
    if (_useMockServiceFlag) {
      _bootstrapMockSession();
    }
  }

  void _bootstrapMockSession() {
    const user = User(
      id: 'demo-user',
      name: 'Demo User',
      email: 'demo@example.com',
      token: 'mock-token',
    );
    _currentUser = user;
    _repository ??= ExpenseRepository(MockExpenseService());
  }

  void _handleAuthenticated(User user) {
    setState(() {
      _currentUser = user;
      _repository =
          widget._repositoryOverride ??
          ExpenseRepository(
            _useMockServiceFlag
                ? MockExpenseService()
                : ExpenseApiService(userId: user.id, authToken: user.token),
          );
    });
  }

  void _handleLogout() {
    setState(() {
      if (!_useMockServiceFlag) {
        _repository = widget._repositoryOverride;
        _currentUser = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = _repository;
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _currentUser == null || repository == null
          ? AuthScreen(
              authRepository: _authRepository,
              onAuthenticated: _handleAuthenticated,
            )
          : DashboardScreen(
              repository: repository,
              user: _currentUser!,
              onLogout: _handleLogout,
            ),
    );
  }
}
