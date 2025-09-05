import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/local_storage.dart';
import '../../app/constants/storage_keys.dart';

/// Supported locales for the app
class AppLocales {
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('bn', ''), // Bengali
  ];
  
  static const Locale defaultLocale = Locale('bn', ''); // Bengali as default for Bangladeshi app
  
  static const Map<String, String> localeNames = {
    'en': 'English',
    'bn': 'বাংলা',
  };
  
  static const Map<String, String> localeNamesNative = {
    'en': 'English',
    'bn': 'বাংলা',
  };
}

/// Provider for managing app locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Provider for checking if Bengali is selected
final isBengaliProvider = Provider<bool>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'bn';
});

/// Provider for getting current locale name
final currentLocaleNameProvider = Provider<String>((ref) {
  final locale = ref.watch(localeProvider);
  return AppLocales.localeNames[locale.languageCode] ?? 'English';
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(AppLocales.defaultLocale) {
    _loadLocale();
  }

  /// Load saved locale from local storage
  Future<void> _loadLocale() async {
    try {
      final savedLanguageCode = await LocalStorage.getString(StorageKeys.locale);
      if (savedLanguageCode != null) {
        final locale = Locale(savedLanguageCode, '');
        if (AppLocales.supportedLocales.contains(locale)) {
          state = locale;
        }
      } else {
        // If no saved locale, check system locale
        _setSystemLocale();
      }
    } catch (e) {
      // If loading fails, keep default locale
      state = AppLocales.defaultLocale;
    }
  }

  /// Set locale based on system preference
  void _setSystemLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    final supportedLanguageCodes = AppLocales.supportedLocales.map((l) => l.languageCode).toList();
    
    if (supportedLanguageCodes.contains(systemLocale.languageCode)) {
      state = Locale(systemLocale.languageCode, '');
    } else {
      state = AppLocales.defaultLocale;
    }
  }

  /// Set locale and save to local storage
  Future<void> setLocale(Locale locale) async {
    if (AppLocales.supportedLocales.contains(locale)) {
      state = locale;
      await LocalStorage.setString(StorageKeys.locale, locale.languageCode);
    }
  }

  /// Set locale by language code
  Future<void> setLocaleByCode(String languageCode) async {
    final locale = Locale(languageCode, '');
    await setLocale(locale);
  }

  /// Toggle between English and Bengali
  Future<void> toggleLanguage() async {
    final newLanguageCode = state.languageCode == 'en' ? 'bn' : 'en';
    await setLocaleByCode(newLanguageCode);
  }

  /// Set to English
  Future<void> setEnglish() async {
    await setLocaleByCode('en');
  }

  /// Set to Bengali
  Future<void> setBengali() async {
    await setLocaleByCode('bn');
  }

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    return AppLocales.localeNames[locale.languageCode] ?? 'Unknown';
  }

  /// Get all supported locales with display names
  Map<Locale, String> getSupportedLocalesWithNames() {
    return Map.fromEntries(
      AppLocales.supportedLocales.map(
        (locale) => MapEntry(locale, getLocaleDisplayName(locale)),
      ),
    );
  }
}