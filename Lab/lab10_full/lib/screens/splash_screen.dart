import 'package:flutter/material.dart';

import '../services/google_auth_service.dart';
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

  @override
  void initState() {
    super.initState();
    _routeUser();
  }

  Future<void> _routeUser() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final hasSession = await _sessionService.hasSession();
    final type = await _sessionService.authType;

    if (hasSession && type == 'google') {
      final user = GoogleAuthService.instance.currentUser;
      if (user != null) {
        _go(const HomeScreen());
        return;
      }
      await _sessionService.clearSession();
    } else if (hasSession && type == 'api') {
      _go(const HomeScreen());
      return;
    }

    _go(const LoginScreen());
  }

  void _go(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              'Lab10 Full',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
