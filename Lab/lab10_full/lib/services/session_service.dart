import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'lab10_token';
  static const _nameKey = 'lab10_name';
  static const _usernameKey = 'lab10_username';
  static const _authTypeKey = 'lab10_auth_type';

  Future<void> saveApiSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = (userData['accessToken'] ?? userData['token'])?.toString();
    if (token == null || token.isEmpty) {
      throw Exception('The API response did not include an access token.');
    }

    final firstName = userData['firstName']?.toString() ?? '';
    final lastName = userData['lastName']?.toString() ?? '';
    final fullName = ('$firstName $lastName').trim();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(
      _nameKey,
      fullName.isEmpty ? (userData['username']?.toString() ?? 'User') : fullName,
    );
    await prefs.setString(_usernameKey, userData['username']?.toString() ?? '');
    await prefs.setString(_authTypeKey, 'api');
  }

  Future<void> saveGoogleSession({
    required String name,
    required String email,
    required String uid,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, uid);
    await prefs.setString(_nameKey, name.isEmpty ? email : name);
    await prefs.setString(_usernameKey, email);
    await prefs.setString(_authTypeKey, 'google');
  }

  Future<String?> get token async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  Future<String?> get name async =>
      (await SharedPreferences.getInstance()).getString(_nameKey);

  Future<String?> get username async =>
      (await SharedPreferences.getInstance()).getString(_usernameKey);

  Future<String?> get authType async =>
      (await SharedPreferences.getInstance()).getString(_authTypeKey);

  Future<bool> hasSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final type = prefs.getString(_authTypeKey);

    return token != null &&
        token.isNotEmpty &&
        (type == 'api' || type == 'google');
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_authTypeKey);
  }
}
