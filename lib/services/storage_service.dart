import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;
  final _secureStorage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _darkModeKey = 'dark_mode';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(_userIdKey, userId);
  }

  int? getUserId() {
    return _prefs.getInt(_userIdKey);
  }

  Future<void> deleteUserId() async {
    await _prefs.remove(_userIdKey);
  }

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_darkModeKey, isDark);
  }

  bool isDarkMode() {
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
