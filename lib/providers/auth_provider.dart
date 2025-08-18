import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  bool get isAuthenticated => _user != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _user = _authService.getCurrentUser();
  }

  Future<String?> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  Future<String?> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();

    return result; // null if success, else error string
  }

  Future<String?> signUpWithGoogle() async {
    return await _authService.signUpWithGoogle();
  }

  Future<String?> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
