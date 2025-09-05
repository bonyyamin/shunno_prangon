class StorageKeys {
  // Authentication
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  
  // User Preferences
  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String firstLaunch = 'first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  
  // App Settings
  static const String notificationsEnabled = 'notifications_enabled';
  static const String pushNotificationsEnabled = 'push_notifications_enabled';
  static const String darkModeEnabled = 'dark_mode_enabled';
  static const String autoSaveDrafts = 'auto_save_drafts';
  static const String offlineReadingEnabled = 'offline_reading_enabled';
  
  // Content
  static const String savedArticles = 'saved_articles';
  static const String readingHistory = 'reading_history';
  static const String drafts = 'drafts';
  static const String recentSearches = 'recent_searches';
  static const String favoriteCategories = 'favorite_categories';
  
  // Cache
  static const String homeContentCache = 'home_content_cache';
  static const String articlesCache = 'articles_cache';
  static const String userProfileCache = 'user_profile_cache';
  static const String categoriesCache = 'categories_cache';
  
  // Timestamps
  static const String lastSyncTimestamp = 'last_sync_timestamp';
  static const String lastRefreshTimestamp = 'last_refresh_timestamp';
}