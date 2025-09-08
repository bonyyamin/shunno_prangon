// lib/features/authentication/domain/usecases/register_usecase.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await _repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}