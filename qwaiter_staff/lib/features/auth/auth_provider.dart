import 'package:flutter/material.dart';
import '../../core/auth_service.dart';

enum AuthStatus { idle, loading, error }

class AuthUser {
  final String id;
  final String? email;
  final String username;
  final String role;
  final String? restaurantID;

  const AuthUser({
    required this.id,
    this.email,
    required this.username,
    required this.role,
    this.restaurantID,
  });

  bool get isOwner => role == 'owner';

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'],
    username: json['username'],
    role: json['role'],
    email: json['email'],
    restaurantID: json['restaurantID'],
  );
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus status = AuthStatus.idle;
  String? errorMessage;
  String? pendingEmail;
  bool isLoggedIn = false;
  AuthUser? currentUser;

  // [] means optional
  void _setState(AuthStatus s, [String? error]) {
    status = s;
    errorMessage = error;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    try {
      final data = await _authService.getMe();
      currentUser = AuthUser.fromJson(data);
      isLoggedIn = true;
    } catch (_) {
      isLoggedIn = false;
      currentUser = null;
    }
    notifyListeners();
  }

  Future<bool> workerLogin(String username, String password) async {
    _setState(AuthStatus.loading);
    try {
      await _authService.workerLogin(username, password);
      await checkAuth();
      _setState(AuthStatus.idle);
      return true;
    } catch (e) {
      _setState(AuthStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> ownerLogin(String email, String password) async {
    _setState(AuthStatus.loading);
    try {
      await _authService.ownerLogin(email, password);
      pendingEmail = email;
      _setState(AuthStatus.idle);
      return true;
    } catch (e) {
      _setState(AuthStatus.error, e.toString());
      return false;
    }
  }

  Future<bool> verifyLogin(String code) async {
    _setState(AuthStatus.loading);
    try {
      await _authService.verifyLogin(pendingEmail!, code);
      pendingEmail = null;
      await checkAuth();
      _setState(AuthStatus.idle);
      return true;
    } catch (e) {
      _setState(AuthStatus.error, e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    isLoggedIn = false;
    currentUser = null;
    notifyListeners();
  }
}
