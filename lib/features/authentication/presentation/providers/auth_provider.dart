// lib/features/authentication/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';

// Data sources providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

// Use cases providers
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.read(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.read(authRepositoryProvider));
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  return ForgotPasswordUseCase(ref.read(authRepositoryProvider));
});

// Auth state provider
final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<domain.User?>>((ref) {
      return AuthNotifier(
        loginUseCase: ref.read(loginUseCaseProvider),
        registerUseCase: ref.read(registerUseCaseProvider),
        logoutUseCase: ref.read(logoutUseCaseProvider),
        getCurrentUserUseCase: ref.read(getCurrentUserUseCaseProvider),
        forgotPasswordUseCase: ref.read(forgotPasswordUseCaseProvider),
        repository: ref.read(authRepositoryProvider),
      );
    });

// Auth state stream provider
final authStateProvider = StreamProvider<domain.User?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.authStateChanges();
});

// Authentication state notifier
class AuthNotifier extends StateNotifier<AsyncValue<domain.User?>> {
  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required AuthRepository repository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _repository = repository,
       super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthRepository _repository;

  Future<void> _checkAuthStatus() async {
    try {
      final user = await _getCurrentUserUseCase();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final user = await _loginUseCase(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    try {
      await _logoutUseCase();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = await _registerUseCase(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _forgotPasswordUseCase(email);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
    String? bio,
  }) async {
    try {
      final updatedUser = await _repository.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
        bio: bio,
      );
      state = AsyncValue.data(updatedUser);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      print('🔧 Auth Provider: sendEmailVerification called');
      await _repository.sendEmailVerification();
      print('🔧 Auth Provider: sendEmailVerification completed successfully');
    } catch (error) {
      print('🔧 Auth Provider: sendEmailVerification failed: $error');
      rethrow;
    }
  }

  Future<bool> isEmailVerified() async {
    try {
      return await _repository.isEmailVerified();
    } catch (error) {
      return false;
    }
  }

  Future<void> refreshUser() async {
    try {
      final user = await _repository.refreshUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _repository.deleteAccount();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

// Convenience providers for UI
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(data: (user) => user != null, orElse: () => false);
});

final currentUserProvider = Provider<domain.User?>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(data: (user) => user, orElse: () => null);
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(loading: () => true, orElse: () => false);
});

final authErrorProvider = Provider<Object?>((ref) {
  return ref
      .watch(authProvider)
      .maybeWhen(error: (error, _) => error, orElse: () => null);
});
