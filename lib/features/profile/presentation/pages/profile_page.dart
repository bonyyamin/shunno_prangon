// lib/features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  
  const ProfilePage({super.key, this.userId});
  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Text(userId != null ? 'User Profile: $userId' : 'My Profile'),
      ),
    );
  }
}