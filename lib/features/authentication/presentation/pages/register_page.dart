// lib/features/authentication/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Register Page - Coming Soon'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.login),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}