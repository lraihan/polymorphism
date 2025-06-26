import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _prefs = await SharedPreferences.getInstance();
  }

  // String operations
  Future<bool> setString(String key, String value) async => _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  // Int operations
  Future<bool> setInt(String key, int value) async => _prefs.setInt(key, value);

  int? getInt(String key) => _prefs.getInt(key);

  // Bool operations
  Future<bool> setBool(String key, {required bool value}) async => _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  // Double operations
  Future<bool> setDouble(String key, double value) async => _prefs.setDouble(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);

  // List operations
  Future<bool> setStringList(String key, List<String> value) async => _prefs.setStringList(key, value);

  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Remove operations
  Future<bool> remove(String key) async => _prefs.remove(key);

  Future<bool> clear() async => _prefs.clear();

  // Check if key exists
  bool containsKey(String key) => _prefs.containsKey(key);

  // Get all keys
  Set<String> getKeys() => _prefs.getKeys();

  // Common app-specific methods
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _isFirstTimeKey = 'is_first_time';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';

  Future<bool> setToken(String token) async => setString(_tokenKey, token);

  String? getToken() => getString(_tokenKey);

  Future<bool> removeToken() async => remove(_tokenKey);

  Future<bool> setUserId(String userId) async => setString(_userIdKey, userId);

  String? getUserId() => getString(_userIdKey);

  Future<bool> setIsFirstTime({required bool isFirstTime}) async => setBool(_isFirstTimeKey, value: isFirstTime);

  bool getIsFirstTime() => getBool(_isFirstTimeKey) ?? true;

  Future<bool> setThemeMode(String themeMode) async => setString(_themeKey, themeMode);

  String getThemeMode() => getString(_themeKey) ?? 'system';

  Future<bool> setLanguage(String language) async => setString(_languageKey, language);

  String getLanguage() => getString(_languageKey) ?? 'en';
}
