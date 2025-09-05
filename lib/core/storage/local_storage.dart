import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    if (_preferences == null) await init();
    return _preferences!.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    if (_preferences == null) await init();
    return _preferences!.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    if (_preferences == null) await init();
    return _preferences!.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    if (_preferences == null) await init();
    return _preferences!.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    if (_preferences == null) await init();
    return _preferences!.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    if (_preferences == null) await init();
    return _preferences!.getInt(key);
  }

  static Future<bool> remove(String key) async {
    if (_preferences == null) await init();
    return _preferences!.remove(key);
  }
}