import 'package:material_ui/material_ui.dart';

/// WHS Egypt 2026 visual identity — wine/burgundy with teal accents.
class WhsColors {
  WhsColors._();

  static const Color burgundy = Color(0xFF6B1E3A);
  static const Color burgundyDeep = Color(0xFF4A1428);
  static const Color burgundySoft = Color(0xFF8E3A58);
  static const Color teal = Color(0xFF1F6F6A);
  static const Color tealSoft = Color(0xFF2A8F88);
  static const Color sand = Color(0xFFF6F0EA);
  static const Color sandDeep = Color(0xFFE8DDD2);
  static const Color ivory = Color(0xFFFFFBF7);
  static const Color ink = Color(0xFF1C1216);
  static const Color inkMuted = Color(0xFF5C4A52);
  static const Color divider = Color(0xFFD6D0C6);
}

class WhsTheme {
  WhsTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: WhsColors.burgundy,
      primary: WhsColors.burgundy,
      secondary: WhsColors.teal,
      surface: WhsColors.ivory,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: WhsColors.sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: WhsColors.burgundyDeep,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: WhsColors.ink,
        ),
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: WhsColors.ink,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          color: WhsColors.ink,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: WhsColors.ink,
        ),
        bodyLarge: TextStyle(height: 1.45, color: WhsColors.inkMuted),
        bodyMedium: TextStyle(height: 1.4, color: WhsColors.inkMuted),
        labelLarge: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: WhsColors.burgundyDeep,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
