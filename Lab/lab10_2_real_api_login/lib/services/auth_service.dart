
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/auth_user.dart';

class AuthService {
  static const String _baseUrl = 'https://dummyjson.com';

  // Send a login request to the authentication API.
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http
          .post(
        uri,
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

      // Return the user when the API request succeeds.
      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        final user = AuthUser.fromJson(data);

        if (user.accessToken.isEmpty) {
          throw Exception('The API did not return an access token.');
        }

        return user;
      }

      // Extract the error message returned by the API.
      final message =
          data['message'] as String? ?? 'Login failed.';

      throw Exception(message);
    } on http.ClientException {
      throw Exception(
        'Network error. Please check your Internet connection.',
      );
    } on FormatException {
      throw Exception('Invalid response from the server.');
    }
  }
}
