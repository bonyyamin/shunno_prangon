// lib/features/authentication/domain/repositories/auth_repository.dart
import '../entities/user.dart';

abstract class AuthRepository {
  /// Check if user is currently authenticated
  Future<bool> isAuthenticated();

  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Login with email and password
  Future<User> login(String email, String password);

  /// Register new user
  Future<User> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Logout current user
  Future<void> logout();

  /// Send password reset email
  Future<void> forgotPassword(String email);

  /// Update user profile
  Future<User> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
  });

  /// Delete user account
  Future<void> deleteAccount();

  /// Stream of authentication state changes
  Stream<User?> authStateChanges();

  /// Verify email address
  Future<void> sendEmailVerification();

  /// Check if email is verified
  Future<bool> isEmailVerified();

  /// Refresh user data
  Future<User> refreshUser();
}