import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors (Cosmic theme inspired by night sky)
  static const Color primaryDark = Color(0xFF1A202D); // Deep space blue-black
  static const Color primaryBlue = Color(0xFF4B5B8B); // Nebula blue
  static const Color accentBlue = Color(0xFF789AD9); // Star blue
  static const Color lightBlue = Color(0xFFA2C7E7); // Galaxy blue
  static const Color background = Color(0xFFF5FAFF); // Cosmic white

  // Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Gray Scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Light Theme Colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryBlue,
    onPrimary: white,
    secondary: accentBlue,
    onSecondary: white,
    tertiary: lightBlue,
    onTertiary: primaryDark,
    surface: white,
    onSurface: primaryDark,
    surfaceContainerHighest: gray100,
    onSurfaceVariant: gray700,
    error: error,
    onError: white,
    outline: gray300,
    outlineVariant: gray200,
    shadow: Colors.black26,
    scrim: Colors.black54,
    inversePrimary: lightBlue,
    inverseSurface: primaryDark,
    onInverseSurface: white,
    surfaceTint: primaryBlue,
  );

  // Dark Theme Colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: accentBlue,
    onPrimary: primaryDark,
    secondary: lightBlue,
    onSecondary: primaryDark,
    tertiary: primaryBlue,
    onTertiary: white,
    surface: Color(0xFF1E1E2E),
    onSurface: white,
    surfaceContainerHighest: Color(0xFF2A2A3E),
    onSurfaceVariant: gray300,
    error: Color(0xFFFF6B6B),
    onError: primaryDark,
    outline: gray600,
    outlineVariant: gray700,
    shadow: Colors.black54,
    scrim: Colors.black87,
    inversePrimary: primaryBlue,
    inverseSurface: background,
    onInverseSurface: primaryDark,
    surfaceTint: accentBlue,
  );

  // Gradient Colors
  static const LinearGradient cosmicGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, accentBlue, lightBlue],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient nightSkyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryBlue],
    stops: [0.0, 1.0],
  );

  static const LinearGradient stardustGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentBlue, lightBlue, background],
    stops: [0.0, 0.7, 1.0],
  );

  // Category Colors
  static const Map<String, Color> categoryColors = {
    'astronomy': Color(0xFF6366F1), // Indigo
    'physics': Color(0xFF8B5CF6), // Violet
    'chemistry': Color(0xFF06B6D4), // Cyan
    'space_exploration': Color(0xFF10B981), // Emerald
    'cosmology': Color(0xFFE11D48), // Rose
    'astrophysics': Color(0xFFF59E0B), // Amber
    'particle_physics': Color(0xFF84CC16), // Lime
    'quantum_mechanics': Color(0xFF3B82F6), // Blue
    'general_science': Color(0xFF6B7280), // Gray
  };

  // Status Colors
  static const Color online = Color(0xFF10B981);
  static const Color offline = Color(0xFF6B7280);
  static const Color draft = Color(0xFFF59E0B);
  static const Color published = Color(0xFF10B981);
  static const Color archived = Color(0xFF6B7280);

  // Social Media Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color youtube = Color(0xFFFF0000);
  static const Color github = Color(0xFF24292E);
}
