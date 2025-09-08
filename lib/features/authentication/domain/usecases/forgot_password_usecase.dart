// lib/features/authentication/domain/usecases/forgot_password_usecase.dart
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call(String email) async {
    return await _repository.forgotPassword(email);
  }
}