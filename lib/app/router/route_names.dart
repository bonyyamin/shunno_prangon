class RouteNames {
  RouteNames._();

  // Core app routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';

  // Authentication routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String profileSetup = '/profile-setup';

  // Main app routes
  static const String discover = '/discover';
  static const String searchResults = '/search-results';
  static const String categoryPage = '/category';

  // Article routes
  static const String articleDetail = '/article';
  static const String articleList = '/articles';
  static const String categoryArticles = '/category-articles';

  // Create article routes
  static const String createArticle = '/create-article';
  static const String drafts = '/drafts';
  static const String publishPreview = '/publish-preview';

  // Profile routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String myArticles = '/my-articles';
  static const String savedArticles = '/saved-articles';

  // Settings routes
  static const String settings = '/settings';
  static const String themeSettings = '/theme-settings';
  static const String languageSettings = '/language-settings';
  static const String notificationSettings = '/notification-settings';
}

class RouteParams {
  RouteParams._();

  // Common parameters
  static const String id = 'id';
  static const String userId = 'userId';
  static const String articleId = 'articleId';
  static const String category = 'category';
  static const String query = 'query';
}