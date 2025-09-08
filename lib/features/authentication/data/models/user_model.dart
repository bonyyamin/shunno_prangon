// lib/features/authentication/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
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
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // Convert from Firestore document
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'],
      photoUrl: data['photo_url'],
      bio: data['bio'],
      articlesCount: data['articles_count'] ?? 0,
      followersCount: data['followers_count'] ?? 0,
      followingCount: data['following_count'] ?? 0,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
      isActive: data['is_active'] ?? true,
      isVerified: data['is_verified'] ?? false,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    // Remove id field as it's handled by Firestore document ID
    json.remove('id');

    // Convert DateTime to Timestamp for Firestore
    if (createdAt != null) {
      json['created_at'] = Timestamp.fromDate(createdAt!);
    }
    if (updatedAt != null) {
      json['updated_at'] = Timestamp.fromDate(updatedAt!);
    }

    return json;
  }

  // Convert to domain entity
  User toEntity() {
    return User(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      articlesCount: articlesCount,
      followersCount: followersCount,
      followingCount: followingCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      isVerified: isVerified,
    );
  }

  // Create from domain entity
  static UserModel fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
      bio: user.bio,
      articlesCount: user.articlesCount,
      followersCount: user.followersCount,
      followingCount: user.followingCount,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
      isVerified: user.isVerified,
    );
  }
}
