import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  static const String _accessTokenKey = 'accessToken';
  static const String _id = 'id';
  static const String _username = 'userName';

  // Save login data
  Future<void> saveLoginDataAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> saveLoginIdData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_id, token);
  }

  Future<void> saveLoginUsernameData(String token) async =>
      await SharedPreferences.getInstance().then(
        (prefs) => prefs.setString(_username, token),
      );

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
