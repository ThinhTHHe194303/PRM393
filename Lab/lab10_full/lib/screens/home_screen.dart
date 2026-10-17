import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/google_auth_service.dart';
import '../services/session_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SessionService _sessionService = SessionService();

  String _name = 'Loading...';
  String _username = '';
  String _authType = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final name = await _sessionService.name;
    final username = await _sessionService.username;
    final authType = await _sessionService.authType;

    if (!mounted) return;
    setState(() {
      _name = name ?? 'User';
      _username = username ?? '';
      _authType = authType ?? '';
    });
  }

  Future<void> _logout() async {
    try {
      if (_authType == 'google') {
        await GoogleAuthService.instance.signOut();
      }

      await _sessionService.clearSession();
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Logout failed.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGoogle = _authType == 'google';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 38,
                    child: Icon(
                      isGoogle ? Icons.account_circle : Icons.person,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _name,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(_username, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Chip(
                    label: Text(
                      isGoogle ? 'Firebase Google Sign-In' : 'DummyJSON REST API',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You have successfully signed in.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
