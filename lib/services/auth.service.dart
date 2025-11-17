import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:barrio_bites/services/user_response.model.dart';

class AuthService {
  final String baseUrl;
  final http.Client client;

  AuthService({required this.baseUrl, http.Client? client})
    : client = client ?? http.Client();

  Future<UserResponse?> checkAuthStatus() async {
    final uri = Uri.parse('$baseUrl/auth');
    final res = await client.get(uri);
    if (res.statusCode != 200) throw Exception('Auth check failed');

    final jsonBody = jsonDecode(res.body);
    final userJson = jsonBody['user'] as Map<String, dynamic>?;

    final user = userJson != null ? UserResponse.fromMap(userJson) : null;

    return user;
  }

  Future<String> loginOtp(String email) async {
    final uri = Uri.parse('$baseUrl/auth/login/otp');
    final res = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email.toLowerCase()}),
    );

    if (res.statusCode != 200) throw Exception('OTP send failed');

    final jsonBody = jsonDecode(res.body);
    return jsonBody['userId'] as String;
  }

  Future<UserResponse> loginOtpverify({
    required String userId,
    required String code,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/login/otp/verify');
    final res = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'code': code}),
    );

    if (res.statusCode != 200) throw Exception('OTP verification failed');

    final jsonBody = jsonDecode(res.body);
    final userJson = jsonBody['user'] as Map<String, dynamic>;
    return UserResponse.fromMap(userJson);
  }

  Future<({bool success})> logout() async {
    final uri = Uri.parse('$baseUrl/auth/logout');
    final res = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode != 200) throw Exception('Logout failed');

    final jsonBody = jsonDecode(res.body) as ({bool success});
    return jsonBody;
  }
}

final authService = AuthService(
  baseUrl: "${dotenv.env['PUBLIC_API_URL']!}/api",
);
