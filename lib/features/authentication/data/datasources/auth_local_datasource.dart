// lib/features/authentication/data/datasources/auth_local_datasource.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> setRememberMe(bool remember);
  Future<bool> getRememberMe();
  Future<void> saveLastLoginEmail(String email);
  Future<String?> getLastLoginEmail();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;

  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _lastEmailKey = 'last_login_email';

  Future<SharedPreferences> get preferences async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = await preferences;
    final userJson = json.encode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final prefs = await preferences;
      final userJson = prefs.getString(_userKey);
      
      if (userJson == null) return null;
      
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // If there's an error parsing cached user, clear it
      await clearCache();
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    final prefs = await preferences;
    await Future.wait([
      prefs.remove(_userKey),
      prefs.remove(_tokenKey),
    ]);
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await preferences;
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await preferences;
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    final prefs = await preferences;
    await prefs.remove(_tokenKey);
  }

  @override
  Future<void> setRememberMe(bool remember) async {
    final prefs = await preferences;
    await prefs.setBool(_rememberMeKey, remember);
  }

  @override
  Future<bool> getRememberMe() async {
    final prefs = await preferences;
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  @override
  Future<void> saveLastLoginEmail(String email) async {
    final prefs = await preferences;
    await prefs.setString(_lastEmailKey, email);
  }

  @override
  Future<String?> getLastLoginEmail() async {
    final prefs = await preferences;
    return prefs.getString(_lastEmailKey);
  }
}