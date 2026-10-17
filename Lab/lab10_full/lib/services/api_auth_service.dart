import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiAuthService {
  static const String _loginUrl = 'https://dummyjson.com/auth/login';

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse(_loginUrl),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username.trim(),
            'password': password,
            'expiresInMins': 30,
          }),
        )
        .timeout(const Duration(seconds: 20));

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        (data['accessToken'] ?? data['token']) != null) {
      return data;
    }

    throw Exception(data['message'] ?? 'Login failed.');
  }
}
