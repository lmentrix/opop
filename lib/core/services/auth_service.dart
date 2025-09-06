import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:opop/core/models/auth_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_request.dart';

class AuthService {
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Replace with actual API URL

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password format (at least 6 characters)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Register a new user
  Future<RegisterModel> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return RegisterModel.fromJson(responseData);
      } else {
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<AuthLogin> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      //save pref
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(
          response.body,
        ); // The error happens here

        return AuthLogin.fromJson(responseData);
      } else {
        // It's possible the status code isn't 200, but is still returning HTML
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
