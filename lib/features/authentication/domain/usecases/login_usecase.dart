// lib/features/authentication/domain/usecases/login_usecase.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email, password);
  }
}