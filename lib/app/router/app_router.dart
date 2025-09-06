import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Onboarding screens
import 'package:shunno_prangon/features/onboarding/presentation/onboarding_screen.dart';
import 'package:shunno_prangon/features/onboarding/presentation/splash_screen.dart';

// Route names
import 'route_names.dart';

// Guards

// Core screens
import '../../features/home/presentation/pages/dashboard.dart';

// Authentication screens
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/pages/profile_setup_page.dart';

// Discovery screens
import '../../features/discover/presentation/pages/discover_page.dart';
import '../../features/discover/presentation/pages/search_results_page.dart';
import '../../features/discover/presentation/pages/category_page.dart';

// Article screens
import '../../features/articles/presentation/pages/article_detail_page.dart';
import '../../features/articles/presentation/pages/article_list_page.dart';
import '../../features/articles/presentation/pages/category_articles_page.dart';

// Create article screens
import '../../features/create_article/presentation/pages/create_article_page.dart';
import '../../features/create_article/presentation/pages/drafts_page.dart';
import '../../features/create_article/presentation/pages/publish_preview_page.dart';

// Profile screens
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/my_articles_page.dart';
import '../../features/profile/presentation/pages/saved_articles_page.dart';

// Settings screens
import '../../features/settings/presentation/pages/theme_settings_page.dart';
import '../../features/settings/presentation/pages/language_settings_page.dart';
import '../../features/settings/presentation/pages/notification_settings_page.dart';
import 'package:shunno_prangon/features/profile/presentation/pages/settings_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // Core app routes
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // GoRoute(
      //   path: RouteNames.selectLanguage,
      //   builder: (context, state) => const SelectLanguageScreen(),
      // ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const Dashboard(),
      ),

      // Authentication routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        builder: (context, state) => const ProfileSetupPage(),
      ),

      // Discovery routes
      GoRoute(
        path: RouteNames.discover,
        builder: (context, state) => const DiscoverPage(),
      ),
      GoRoute(
        path: RouteNames.searchResults,
        builder: (context, state) {
          final query = state.uri.queryParameters[RouteParams.query] ?? '';
          return SearchResultsPage(query: query);
        },
      ),
      GoRoute(
        path: '${RouteNames.categoryPage}/:${RouteParams.category}',
        builder: (context, state) {
          final category = state.pathParameters[RouteParams.category]!;
          return CategoryPage(category: category);
        },
      ),

      // Article routes
      GoRoute(
        path: '${RouteNames.articleDetail}/:${RouteParams.articleId}',
        builder: (context, state) {
          final articleId = state.pathParameters[RouteParams.articleId]!;
          return ArticleDetailPage(articleId: articleId);
        },
      ),
      GoRoute(
        path: RouteNames.articleList,
        builder: (context, state) => const ArticleListPage(),
      ),
      GoRoute(
        path: '${RouteNames.categoryArticles}/:${RouteParams.category}',
        builder: (context, state) {
          final category = state.pathParameters[RouteParams.category]!;
          return CategoryArticlesPage(category: category);
        },
      ),

      // Create article routes
      GoRoute(
        path: RouteNames.createArticle,
        builder: (context, state) {
          final articleId = state.uri.queryParameters[RouteParams.articleId];
          return CreateArticlePage(articleId: articleId);
        },
      ),
      GoRoute(
        path: RouteNames.drafts,
        builder: (context, state) => const DraftsPage(),
      ),
      GoRoute(
        path: '${RouteNames.publishPreview}/:${RouteParams.articleId}',
        builder: (context, state) {
          final articleId = state.pathParameters[RouteParams.articleId]!;
          return PublishPreviewPage(articleId: articleId);
        },
      ),

      // Profile routes
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) {
          final userId = state.uri.queryParameters[RouteParams.userId];
          return ProfilePage(userId: userId);
        },
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.myArticles,
        builder: (context, state) => const MyArticlesPage(),
      ),
      GoRoute(
        path: RouteNames.savedArticles,
        builder: (context, state) => const SavedArticlesPage(),
      ),

      // Settings routes
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.themeSettings,
        builder: (context, state) => const ThemeSettingsPage(),
      ),
      GoRoute(
        path: RouteNames.languageSettings,
        builder: (context, state) => const LanguageSettingsPage(),
      ),
      GoRoute(
        path: RouteNames.notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Oops! Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.toString()}" does not exist.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // ElevatedButton(
            //   onPressed: () {
            //     context.go(RouteNames.home);
            //   },
            //   child: const Text('Go Home'),
            // ),
          ],
        ),
      ),
    ),
  );
});
