import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instructor_auto/config/app_config.dart';
import 'package:instructor_auto/models/user.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  late SharedPreferences _prefs;

  factory SharedPreferencesService() => _instance;

  SharedPreferencesService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConfig.tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(AppConfig.tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _prefs.setString(AppConfig.refreshTokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(AppConfig.refreshTokenKey);
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString(AppConfig.userKey, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    final userStr = _prefs.getString(AppConfig.userKey);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
