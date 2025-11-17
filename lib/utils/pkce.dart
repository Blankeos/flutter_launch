// PKCE Utilities
// Works in NativeScript, React Native, Browser, Node.
// But actually considering the Buffer and btoa here, just polyfill it in NativeScript (v8)

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Used in client only.
String generateCodeVerifier([int length = 64]) {
  final random = Random.secure();
  final chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~";

  return List.generate(
    length,
    (_) => chars[random.nextInt(chars.length)],
  ).join();
}

/// Used in client and server.
Future<String> generateCodeChallenge(String codeVerifier) async {
  final bytes = utf8.encode(codeVerifier);
  final hash = sha256.convert(bytes);
  return base64UrlEncode(hash.bytes);
}

/// Used in server only.
Future<bool> verifyCodeVerifier(
  String codeVerifier,
  String expectedChallenge,
) async {
  final actual = await generateCodeChallenge(codeVerifier);
  return actual == expectedChallenge;
}

// ---------------------------------------------------------------------
// Base64URL encoder (NO Buffer, NO btoa) → works everywhere including NativeScript
// ---------------------------------------------------------------------

const base64Alphabet =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

String base64Encode(List<int> bytes) {
  String result = "";
  int i;

  for (i = 0; i + 2 < bytes.length; i += 3) {
    final combined = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2];

    result += base64Alphabet[(combined >> 18) & 63];
    result += base64Alphabet[(combined >> 12) & 63];
    result += base64Alphabet[(combined >> 6) & 63];
    result += base64Alphabet[combined & 63];
  }

  if (i < bytes.length) {
    int combined = bytes[i] << 16;
    String padding = "";

    if (i + 1 < bytes.length) {
      combined |= bytes[i + 1] << 8;
      padding = "=";
    } else {
      padding = "==";
    }

    result += base64Alphabet[(combined >> 18) & 63];
    result += base64Alphabet[(combined >> 12) & 63];
    result += padding == "==" ? "==" : base64Alphabet[(combined >> 6) & 63];
    result += padding == "=" ? "=" : "";
  }

  return result;
}

String base64UrlEncode(List<int> bytes) {
  return base64Encode(
    bytes,
  ).replaceAll('+', '-').replaceAll('/', '_').replaceAll(RegExp(r'=+$'), '');
}
