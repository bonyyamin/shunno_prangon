class AppConstants {
  // App Info
  static const String appName = 'Shunno Prangon';
  static const String appNameBn = 'শূন্য প্রাঙ্গণ';
  static const String appMotto = 'Connecting minds, one star at a time.';
  static const String appMottoBn = 'এক নক্ষত্রে মনের মিলন।';
  
  // Version
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  static const double cardElevation = 2.0;
  static const double modalElevation = 8.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Text Limits
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxArticleContentLength = 50000;
  static const int maxBioLength = 160;
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;
  
  // Image Constraints
  static const int maxImageSizeMB = 5;
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  
  // Categories
  static const List<String> categories = [
    'astronomy',
    'physics',
    'chemistry',
    'space_exploration',
    'cosmology',
    'astrophysics',
    'particle_physics',
    'quantum_mechanics',
    'general_science',
  ];
  
  static const Map<String, String> categoriesInBengali = {
    'astronomy': 'জ্যোতির্বিদ্যা',
    'physics': 'পদার্থবিজ্ঞান',
    'chemistry': 'রসায়ন',
    'space_exploration': 'মহাকাশ অনুসন্ধান',
    'cosmology': 'বিশ্বতত্ত্ব',
    'astrophysics': 'জ্যোতিঃপদার্থবিজ্ঞান',
    'particle_physics': 'কণা পদার্থবিজ্ঞান',
    'quantum_mechanics': 'কোয়ান্টাম বলবিদ্যা',
    'general_science': 'সাধারণ বিজ্ঞান',
  };
}