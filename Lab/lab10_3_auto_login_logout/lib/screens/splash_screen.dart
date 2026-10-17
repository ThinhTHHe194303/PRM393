
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SessionService _sessionService = SessionService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Check the saved session before opening the main screen.
  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final token = await _sessionService.getAccessToken();

      if (!mounted) return;

      if (token == null || token.isEmpty) {
        _openLogin();
        return;
      }

      final user = await _authService.getCurrentUser(token);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: user),
        ),
      );
    } catch (_) {
      await _sessionService.clearSession();

      if (!mounted) return;

      _openLogin();
    }
  }

  // Navigate to the login screen and remove the splash route.
  void _openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 72,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              'Lab 10.3',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            const Text('Checking session...'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
