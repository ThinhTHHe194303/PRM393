
class MockAuthService {
  // Simulate a backend login request.
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    // Use test credentials for the mock login.
    if (email == 'student@example.com' &&
        password == '123456') {
      return 'mock_token_12345';
    }

    return null;
  }
}
