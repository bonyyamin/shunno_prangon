// lib/features/authentication/data/models/auth_response_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required UserModel user,
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
    @Default('Bearer') String tokenType,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  // Create from Firebase Auth User and custom claims
  factory AuthResponseModel.fromFirebaseUser({
    required UserModel user,
    required String idToken,
    String? refreshToken,
  }) {
    return AuthResponseModel(
      user: user,
      accessToken: idToken,
      refreshToken: refreshToken,
      expiresIn: 3600, // 1 hour in seconds
    );
  }
}
