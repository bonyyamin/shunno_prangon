// lib/features/authentication/domain/usecases/get_current_user_usecase.dart
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<User?> call() async {
    return await _repository.getCurrentUser();
  }

  Stream<User?> stream() {
    return _repository.authStateChanges();
  }
}