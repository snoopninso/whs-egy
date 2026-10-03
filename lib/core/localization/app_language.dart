import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class AppLanguage {
  static const _languageKey = 'app_language_code';
  static final ValueNotifier<String> languageCode = ValueNotifier('en');

  static Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedCode = preferences.getString(_languageKey);
    if (savedCode == 'ar' || savedCode == 'en') {
      languageCode.value = savedCode!;
    }
  }

  static Future<void> setLanguageCode(String code) async {
    if (code != 'ar' && code != 'en') return;
    languageCode.value = code;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageKey, code);
  }
}
