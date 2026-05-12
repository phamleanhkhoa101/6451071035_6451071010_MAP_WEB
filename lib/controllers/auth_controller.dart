import 'package:flutter/material.dart';

import '../data/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  bool _isLoggedIn = false;
  bool _isCheckingLogin = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckingLogin => _isCheckingLogin;

  Future<void> checkLogin() async {
    _isCheckingLogin = true;
    notifyListeners();

    _isLoggedIn = await _service.isLoggedIn();
    _isCheckingLogin = false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final success = await _service.login(username, password);
    _isLoggedIn = success;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _service.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
