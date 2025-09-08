// lib/features/authentication/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    String? bio,
    @Default(0) int articlesCount,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(true) bool isActive,
    @Default(false) bool isVerified,
  }) = _User;

  const User._();

  String get initials {
    if (displayName?.isNotEmpty == true) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  String get displayNameOrEmail => displayName ?? email;

  bool get hasProfilePicture => photoUrl?.isNotEmpty == true;

  bool get isProfileComplete {
    return displayName?.isNotEmpty == true && bio?.isNotEmpty == true;
  }
}