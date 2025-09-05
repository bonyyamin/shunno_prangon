import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage.dart';
import '../../app/constants/storage_keys.dart';


/// Provider for managing app theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Provider for checking if dark mode is enabled
final isDarkModeProvider = Provider<bool>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  if (themeMode == ThemeMode.system) {
    // Get system brightness
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
  return themeMode == ThemeMode.dark;
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  /// Load saved theme mode from local storage
  Future<void> _loadThemeMode() async {
    try {
      final savedThemeModeIndex = await LocalStorage.getInt(StorageKeys.themeMode);
      if (savedThemeModeIndex != null) {
        state = ThemeMode.values[savedThemeModeIndex];
      }
    } catch (e) {
      // If loading fails, keep default system theme
      state = ThemeMode.system;
    }
  }

  /// Set theme mode and save to local storage
  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await LocalStorage.setInt(StorageKeys.themeMode, themeMode.index);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newTheme);
  }

  /// Set to system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Set to light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set to dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }
}