// lib/features/authentication/data/repositories/auth_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<bool> isAuthenticated() async {
    try {
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser == null) return false;

      // Verify with remote if user exists
      final remoteUser = await _remoteDataSource.getCurrentUser();
      return remoteUser != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser.toEntity();
      }

      // If not in cache, get from remote
      final remoteUser = await _remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        await _localDataSource.cacheUser(remoteUser);
        return remoteUser.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final loginRequest = LoginRequestModel(email: email, password: password);
    final authResponse = await _remoteDataSource.login(loginRequest);
    await _localDataSource.cacheUser(authResponse.user);
    return authResponse.user.toEntity();
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final registerRequest = RegisterRequestModel(
      email: email,
      password: password,
      displayName: displayName,
    );
    final authResponse = await _remoteDataSource.register(registerRequest);
    await _localDataSource.cacheUser(authResponse.user);
    return authResponse.user.toEntity();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearCache();
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _remoteDataSource.forgotPassword(email);
  }

  @override
  Future<User> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
  }) async {
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      throw Exception('User not authenticated');
    }

    final updates = <String, dynamic>{};
    if (displayName != null) {
      updates['display_name'] = displayName;
    }
    if (photoUrl != null) {
      updates['photo_url'] = photoUrl;
    }
    if (bio != null) {
      updates['bio'] = bio;
    }

    final userModel = await _remoteDataSource.updateUserProfile(
      currentUser.id,
      updates,
    );
    await _localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<void> deleteAccount() async {
    await _remoteDataSource.deleteAccount();
    await _localDataSource.clearCache();
  }

  @override
  Stream<User?> authStateChanges() {
    return _remoteDataSource.authStateChanges().map((userModel) {
      if (userModel != null) {
        _localDataSource.cacheUser(userModel);
        return userModel.toEntity();
      } else {
        _localDataSource.clearCache();
        return null;
      }
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    print('🔧 Auth Repository: sendEmailVerification called');
    await _remoteDataSource.sendEmailVerification();
    print('🔧 Auth Repository: sendEmailVerification completed');
  }

  @override
  Future<bool> isEmailVerified() async {
    return await _remoteDataSource.isEmailVerified();
  }

  @override
  Future<User> refreshUser() async {
    final userModel = await _remoteDataSource.refreshUser();
    await _localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }
}
