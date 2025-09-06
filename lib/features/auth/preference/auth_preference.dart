import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  static const String _accessTokenKey = 'accessToken';
  static const String _id = 'id';

  // Save login data
  Future<void> saveLoginDataAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveLoginIdData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_id, token);
  }

  // Get login data
  Future<String?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Optional: Clear login data
  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}
