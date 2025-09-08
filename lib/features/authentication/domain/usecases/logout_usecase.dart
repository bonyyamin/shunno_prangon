// lib/features/authentication/domain/usecases/logout_usecase.dart
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() async {
    return await _repository.logout();
  }
}