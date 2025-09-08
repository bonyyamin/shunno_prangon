// lib/features/authentication/data/datasources/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  );
  Future<void> deleteAccount();
  Stream<UserModel?> authStateChanges();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
  Future<UserModel> refreshUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static const String _usersCollection = 'users';

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      final user = credential.user;
      if (user == null) {
        throw const AuthException(
          code: 'user-not-found',
          message: 'No user found after login',
        );
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .get();

      UserModel userModel;
      if (userDoc.exists) {
        userModel = UserModel.fromFirestore(userDoc);
      } else {
        // Create user document if it doesn't exist
        userModel = UserModel(
          id: user.uid,
          email: user.email!,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _createUserDocument(userModel);
      }

      // Get ID token
      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw const AuthException(
          code: 'token-not-found',
          message: 'Failed to get ID token',
        );
      }

      return AuthResponseModel.fromFirebaseUser(
        user: userModel,
        idToken: idToken,
        refreshToken: user.refreshToken,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      print('🔥 Firebase Auth: Creating user with email: ${request.email}');

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: request.email,
        password: request.password,
      );

      print('🔥 Firebase Auth: User created successfully');

      final user = credential.user;
      if (user == null) {
        print('❌ Firebase Auth: No user returned after registration');
        throw const AuthException(
          code: 'user-not-created',
          message: 'No user created after registration',
        );
      }

      print('🔥 Firebase Auth: User UID: ${user.uid}');
      print('🔥 Firebase Auth: User email: ${user.email}');
      print('🔥 Firebase Auth: Email verified: ${user.emailVerified}');

      // Update Firebase Auth profile
      print(
        '🔥 Firebase Auth: Updating display name to: ${request.displayName}',
      );
      await user.updateDisplayName(request.displayName);
      if (request.photoUrl != null) {
        await user.updatePhotoURL(request.photoUrl);
      }

      // Create user document in Firestore
      final userModel = UserModel(
        id: user.uid,
        email: user.email!,
        displayName: request.displayName,
        photoUrl: request.photoUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _createUserDocument(userModel);

      // Get ID token
      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw const AuthException(
          code: 'token-not-found',
          message: 'Failed to get ID token',
        );
      }

      return AuthResponseModel.fromFirebaseUser(
        user: userModel,
        idToken: idToken,
        refreshToken: user.refreshToken,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(code: 'unknown', message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }

      return null;
    } catch (e) {
      throw AuthException(code: 'get-user-failed', message: e.toString());
    }
  }

  @override
  Future<UserModel> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      // Update Firestore document
      await _firestore.collection(_usersCollection).doc(userId).update({
        ...updates,
        'updated_at': FieldValue.serverTimestamp(),
      });

      // Update Firebase Auth profile if needed
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        if (updates.containsKey('display_name')) {
          await user.updateDisplayName(updates['display_name']);
        }
        if (updates.containsKey('photo_url')) {
          await user.updatePhotoURL(updates['photo_url']);
        }
      }

      // Get updated user data
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      return UserModel.fromFirestore(userDoc);
    } catch (e) {
      throw AuthException(code: 'update-profile-failed', message: e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const AuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      // Delete user document from Firestore
      await _firestore.collection(_usersCollection).doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuthException(e);
    } catch (e) {
      throw AuthException(code: 'delete-account-failed', message: e.toString());
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      try {
        final userDoc = await _firestore
            .collection(_usersCollection)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromFirestore(userDoc);
        }
        return null;
      } catch (e) {
        return null;
      }
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      print('📧 Email Verification: Getting current user...');
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        print('❌ Email Verification: No current user found');
        throw const AuthException(
          code: 'no-current-user',
          message: 'No user is currently signed in',
        );
      }

      print('📧 Email Verification: Current user found - ${user.email}');
      print('📧 Email Verification: User UID - ${user.uid}');
      print(
        '📧 Email Verification: Email verified status - ${user.emailVerified}',
      );
      print('📧 Email Verification: Sending verification email...');

      await user.sendEmailVerification();

      print('✅ Email Verification: Verification email sent successfully!');
    } on firebase_auth.FirebaseAuthException catch (e) {
      print(
        '❌ Email Verification: Firebase Auth Exception - ${e.code}: ${e.message}',
      );
      throw AuthException.fromFirebaseAuthException(e);
    } catch (e) {
      print('❌ Email Verification: General Exception - $e');
      rethrow;
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;

    await user.reload();
    return user.emailVerified;
  }

  @override
  Future<UserModel> refreshUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const AuthException(
        code: 'no-current-user',
        message: 'No user is currently signed in',
      );
    }
    await user.reload();
    final userDoc = await _firestore
        .collection(_usersCollection)
        .doc(user.uid)
        .get();
    return UserModel.fromFirestore(userDoc);
  }

  Future<void> _createUserDocument(UserModel userModel) async {
    await _firestore
        .collection(_usersCollection)
        .doc(userModel.id)
        .set(userModel.toFirestore());
  }
}

// Custom exception class
class AuthException implements Exception {
  const AuthException({required this.code, required this.message});

  factory AuthException.fromFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    return AuthException(code: e.code, message: _getLocalizedMessage(e.code));
  }

  final String code;
  final String message;

  static String _getLocalizedMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'এই ইমেইল ঠিকানা দিয়ে কোন অ্যাকাউন্ট পাওয়া যায়নি';
      case 'wrong-password':
        return 'ভুল পাসওয়ার্ড';
      case 'email-already-in-use':
        return 'এই ইমেইল ইতিমধ্যে ব্যবহৃত হচ্ছে';
      case 'weak-password':
        return 'পাসওয়ার্ড খুবই দুর্বল';
      case 'invalid-email':
        return 'ইমেইল ঠিকানা সঠিক নয়';
      case 'user-disabled':
        return 'এই অ্যাকাউন্ট নিষ্ক্রিয় করা হয়েছে';
      case 'too-many-requests':
        return 'অনেক বেশি চেষ্টা করা হয়েছে। পরে আবার চেষ্টা করুন';
      case 'operation-not-allowed':
        return 'এই অপারেশন অনুমোদিত নয়';
      default:
        return 'একটি অপ্রত্যাশিত ত্রুটি ঘটেছে';
    }
  }

  @override
  String toString() => 'AuthException(code: $code, message: $message)';
}
