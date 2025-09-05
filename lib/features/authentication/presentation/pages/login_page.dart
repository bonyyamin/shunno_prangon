// lib/features/authentication/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page - Coming Soon'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.register),
              child: const Text('Go to Register'),
            ),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Skip to Home'),
            ),
          ],
        ),
      ),
    );
  }
}