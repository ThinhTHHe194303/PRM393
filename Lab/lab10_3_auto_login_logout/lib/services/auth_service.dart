
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/auth_user.dart';

class AuthService {
  static const String _baseUrl = 'https://dummyjson.com';

  // Authenticate the user through the DummyJSON API.
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await http
        .post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    )
        .timeout(const Duration(seconds: 15));

    final Map<String, dynamic> data =
    jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      final user = AuthUser.fromJson(data);

      if (user.accessToken.isEmpty) {
        throw Exception('Access token was not returned.');
      }

      return user;
    }

    throw Exception(
      data['message'] as String? ?? 'Login failed.',
    );
  }

  // Retrieve the current user using the saved access token.
  Future<AuthUser> getCurrentUser(String accessToken) async {
    final response = await http
        .get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

      return AuthUser.fromJson(data);
    }

    throw Exception('Session expired. Please log in again.');
  }
}
