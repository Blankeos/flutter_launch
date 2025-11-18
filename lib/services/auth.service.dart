import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_launch/services/user_response.model.dart';

class AuthService {
  final String baseUrl;
  final Dio dio;

  AuthService._({required this.baseUrl, required this.dio});

  static Future<AuthService> create({required String baseUrl, Dio? dio}) async {
    final dioInstance =
        dio ??
        Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            validateStatus: (status) =>
                true, // Handle all status codes manually
          ),
        );

    // Add cookie manager for automatic cookie handling
    await _setupCookieManager(dioInstance);

    return AuthService._(baseUrl: baseUrl, dio: dioInstance);
  }

  static Future<void> _setupCookieManager(Dio dio) async {
    try {
      // For mobile/desktop: persist cookies to disk
      final appDocDir = await getApplicationDocumentsDirectory();
      final cookieJar = PersistCookieJar(
        storage: FileStorage('${appDocDir.path}/.cookies/'),
      );
      dio.interceptors.add(CookieManager(cookieJar));
    } catch (e) {
      // Fallback to memory-only cookies if file storage fails
      final cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
    }
  }

  Future<UserResponse?> checkAuthStatus() async {
    final uri = '$baseUrl/auth';
    final res = await dio.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Auth check failed: ${res.statusCode}');
    }

    final jsonBody = res.data as Map<String, dynamic>;
    final userJson = jsonBody['user'] as Map<String, dynamic>?;

    return userJson != null ? UserResponse.fromMap(userJson) : null;
  }

  Future<String> loginOtp(String email) async {
    final uri = '$baseUrl/auth/login/otp';
    final res = await dio.post(
      uri,
      data: {'email': email.toLowerCase()},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (res.statusCode != 200) {
      throw Exception('OTP send failed: ${res.statusCode}');
    }

    final jsonBody = res.data as Map<String, dynamic>;
    return jsonBody['userId'] as String;
  }

  Future<UserResponse> loginOtpverify({
    required String userId,
    required String code,
  }) async {
    final uri = '$baseUrl/auth/login/otp/verify';
    final res = await dio.post(
      uri,
      data: {'userId': userId, 'code': code},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (res.statusCode != 200) {
      throw Exception('OTP verification failed: ${res.statusCode}');
    }

    final jsonBody = res.data as Map<String, dynamic>;
    final userJson = jsonBody['user'] as Map<String, dynamic>;

    // Cookies are automatically saved by CookieManager
    return UserResponse.fromMap(userJson);
  }

  Future<bool> logout() async {
    final uri = '$baseUrl/auth/logout';
    final res = await dio.get(
      uri,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (res.statusCode != 200) {
      throw Exception('Logout failed: ${res.statusCode}');
    }

    final jsonBody = res.data as Map<String, dynamic>;
    return jsonBody['success'] as bool? ?? false;
  }

  Future<UserResponse?> loginOAuthToken(
    ({String authCode, String codeVerifier}) params,
  ) async {
    final uri = '$baseUrl/auth/login/token';
    final res = await dio.post(
      uri,
      data: {
        'auth_code': params.authCode,
        'code_verifier': params.codeVerifier,
      },
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (res.statusCode != 200) {
      throw Exception('Login with token failed: ${res.statusCode}');
    }

    final jsonBody = res.data as Map<String, dynamic>;
    final userJson = jsonBody['user'] as Map<String, dynamic>;

    return UserResponse.fromMap(userJson);
  }

  /// Clear all stored cookies (useful for logout cleanup)
  Future<void> clearCookies() async {
    try {
      final cookieManager = dio.interceptors
          .whereType<CookieManager>()
          .firstOrNull;

      if (cookieManager != null) {
        await cookieManager.cookieJar.deleteAll();
      }
    } catch (e) {
      // Silently fail if cookie clearing fails
    }
  }
}

final getAuthService = AuthService.create(
  baseUrl: "${dotenv.env['PUBLIC_API_URL']!}/api",
);
