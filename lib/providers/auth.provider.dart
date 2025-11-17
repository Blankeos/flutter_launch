import 'package:barrio_bites/services/auth.service.dart';
import 'package:barrio_bites/services/user_response.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:command_it/command_it.dart';

class AuthProvider with ChangeNotifier {
  String? _error;
  String? get error => _error;

  UserResponse? _user;
  UserResponse? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    getCurrentUser();
  }

  // Get user profile
  Future<void> getCurrentUser() async {
    final result = await authService.checkAuthStatus();
    print("[auth.provider] getCurrentUser $result");
    _user = result;
  }

  final loginOtpCommand = Command.createAsync<String, String?>((email) async {
    final userId = await authService.loginOtp(email);
    return userId;
  }, initialValue: null);

  late final verifyOtpCommand =
      Command.createAsync<({String userId, String code}), UserResponse?>((
        params,
      ) async {
        try {
          final result = await authService.loginOtpverify(
            userId: params.userId,
            code: params.code,
          );
          print("YOOO I LOGGED IN!! $result");
          _user = result;
          return result;
        } catch (err) {
          print("[][][] erorr: $err");
        }
      }, initialValue: null);

  final logoutCommand = Command.createAsync<void, ({bool success})>((_) async {
    final result = await authService.logout();
    return result;
  }, initialValue: (success: false));
}

AuthProvider useAuth(BuildContext context, {bool listen = true}) {
  return Provider.of<AuthProvider>(context, listen: listen);
}
