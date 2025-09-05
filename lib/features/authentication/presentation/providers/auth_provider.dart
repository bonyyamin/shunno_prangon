// lib/features/authentication/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock user entity for demonstration
class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Simulate checking authentication status
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo purposes, user is not authenticated initially
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate sign in
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '123',
        email: email,
        displayName: 'Test User',
      );
      
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate sign out
      await Future.delayed(const Duration(milliseconds: 500));
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate registration
      await Future.delayed(const Duration(seconds: 1));
      
      final user = User(
        id: '124',
        email: email,
        displayName: name,
      );
      
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}