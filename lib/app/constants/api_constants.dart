class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.shunnoprangon.com';
  static const String firebaseStorageUrl = 'https://firebasestorage.googleapis.com/v0/b/shunno-prangon.appspot.com';
  
  // API Versions
  static const String apiVersion = 'v1';
  
  // Endpoints
  static const String auth = '/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  
  static const String users = '/users';
  static const String userProfile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String userStats = '$users/stats';
  static const String userArticles = '$users/articles';
  static const String savedArticles = '$users/saved-articles';
  
  static const String articles = '/articles';
  static const String createArticle = articles;
  static const String updateArticle = articles; // + /{id}
  static const String deleteArticle = articles; // + /{id}
  static const String getArticle = articles; // + /{id}
  static const String searchArticles = '$articles/search';
  static const String featuredArticles = '$articles/featured';
  static const String trendingArticles = '$articles/trending';
  static const String recentArticles = '$articles/recent';
  
  static const String categories = '/categories';
  static const String categoryArticles = categories; // + /{category}/articles
  
  static const String drafts = '/drafts';
  static const String saveDraft = drafts;
  static const String deleteDraft = drafts; // + /{id}
  static const String publishDraft = '$drafts/publish'; // + /{id}
  
  static const String media = '/media';
  static const String uploadImage = '$media/images';
  static const String uploadFile = '$media/files';
  
  // Headers
  static const String authHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  
  // Query Parameters
  static const String pageParam = 'page';
  static const String limitParam = 'limit';
  static const String sortParam = 'sort';
  static const String orderParam = 'order';
  static const String searchParam = 'q';
  static const String categoryParam = 'category';
  static const String tagParam = 'tag';
  static const String authorParam = 'author';
  
  // Error Codes
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String notFound = 'NOT_FOUND';
  static const String validationError = 'VALIDATION_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String networkError = 'NETWORK_ERROR';
  
  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}