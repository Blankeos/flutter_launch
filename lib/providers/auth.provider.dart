import 'package:barrio_bites/services/auth.service.dart';
import 'package:barrio_bites/services/user_response.model.dart';
import 'package:barrio_bites/utils/pkce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:command_it/command_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  bool _initialized = false;
  bool get initialized => _initialized;

  String? _error;
  String? get error => _error;

  bool _loading = false;
  bool get loading => _loading;

  UserResponse? _user;
  UserResponse? get user => _user;
  bool get isAuthenticated => _user != null;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  late AuthService authService;

  // Call this manually after provider is set up
  Future<void> init() async {
    authService = await getAuthService;
    if (_initialized) return; // Prevent double initialization

    _loading = true;
    notifyListeners();

    await getCurrentUser();

    _initialized = true;
    _loading = false;
    notifyListeners();
  }

  // Get user profile
  Future<void> getCurrentUser() async {
    _loading = true;
    notifyListeners();

    final result = await authService.checkAuthStatus();
    _user = result;
    _loading = false;

    notifyListeners();
  }

  late final loginOtpCommand = Command.createAsync<String, String?>((
    email,
  ) async {
    final userId = await authService.loginOtp(email);
    return userId;
  }, initialValue: null);

  late final verifyOtpCommand =
      Command.createAsync<({String userId, String code}), UserResponse?>((
        params,
      ) async {
        final result = await authService.loginOtpverify(
          userId: params.userId,
          code: params.code,
        );
        _user = result;
        notifyListeners();
        return result;
      }, initialValue: null);

  late final logoutCommand = Command.createAsync<void, bool>((_) async {
    final result = await authService.logout();
    _user = null;
    notifyListeners();
    return result;
  }, initialValue: false);

  Future<String> getLoginGoogleUrl() async {
    final codeVerifier = generateCodeVerifier();
    final codeChallenge = await generateCodeChallenge(codeVerifier);

    await _secureStorage.write(key: 'code_verifier', value: codeVerifier);

    final baseUrl = dotenv.env['PUBLIC_API_URL'] ?? '';
    final redirectUrl = 'flutterlaunch:///oauth_callback';

    return '$baseUrl/api/auth/login/google?'
        'redirect_url=$redirectUrl&'
        'client_code_challenge=$codeChallenge';
  }

  late final loginOAuthTokenCommand =
      Command.createAsync<String, UserResponse?>((authCode) async {
        final codeVerifier = await _secureStorage.read(key: 'code_verifier');
        if (codeVerifier == null) {
          throw Exception('No code verifier found in secure storage');
        }

        final result = await authService.loginOAuthToken((
          authCode: authCode,
          codeVerifier: codeVerifier,
        ));

        _user = result;
        notifyListeners();
        return result;
      }, initialValue: null);
}

AuthProvider useAuth(BuildContext context, {bool listen = true}) {
  return Provider.of<AuthProvider>(context, listen: listen);
}
