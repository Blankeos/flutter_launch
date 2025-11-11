import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    notifyListeners();
    debugPrint('User logged in');
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
    debugPrint('User logged out');
  }
}

AuthProvider useAuth(BuildContext context, {bool listen = true}) {
  return Provider.of<AuthProvider>(context, listen: listen);
}
