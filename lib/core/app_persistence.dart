import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPersistence {
  AppPersistence._();

  static const String _loggedInEmailKey = 'logged_in_email';
  static const String _loggedInKey = 'is_logged_in';
  static const String _registrationRequestsKey = 'registration_requests';

  static Future<void> saveLoggedInUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_loggedInEmailKey, email.trim());
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
    await prefs.remove(_loggedInEmailKey);
  }

  static Future<void> saveRegistrationRequest(
    Map<String, String> request,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_registrationRequestsKey) ?? <String>[];
    current.insert(0, jsonEncode(request));
    await prefs.setStringList(_registrationRequestsKey, current);
  }

  static Future<Map<String, String>?> latestRegistrationRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final requests = prefs.getStringList(_registrationRequestsKey);
    if (requests == null || requests.isEmpty) return null;

    try {
      final decoded = jsonDecode(requests.first);
      if (decoded is Map<String, dynamic>) {
        return decoded.map(
          (key, value) => MapEntry(key, value?.toString() ?? ''),
        );
      }
    } on FormatException {
      return null;
    }
    return null;
  }
}
