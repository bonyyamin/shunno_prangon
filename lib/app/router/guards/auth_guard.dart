import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/features/authentication/presentation/providers/auth_provider.dart';
import 'package:shunno_prangon/features/onboarding/presentation/provider/onboarding_provider.dart';

class AuthGuard {
  static String? redirectLogic(GoRouterState state, Ref ref) {
    final authState = ref.read(authProvider);
    final hasCompletedOnboarding = ref.read(onboardingProvider);

    // Check if user has completed onboarding first
    if (!hasCompletedOnboarding &&
        state.uri.toString() != RouteNames.onboarding) {
      return RouteNames.onboarding;
    }

    // Protected routes that require authentication
    final protectedRoutes = [
      RouteNames.createArticle,
      RouteNames.drafts,
      RouteNames.publishPreview,
      RouteNames.profile,
      RouteNames.editProfile,
      RouteNames.myArticles,
      RouteNames.savedArticles,
      RouteNames.settings,
      RouteNames.themeSettings,
      RouteNames.languageSettings,
      RouteNames.notificationSettings,
    ];

    // Check if current route requires authentication
    final requiresAuth = protectedRoutes.any(
      (route) => state.uri.toString().startsWith(route),
    );

    if (requiresAuth) {
      return authState.when(
        data: (user) {
          if (user == null) {
            // User not authenticated, redirect to login
            return RouteNames.login;
          }
          // Check if user needs to complete profile setup
          if (user.displayName == null || user.displayName!.isEmpty) {
            return RouteNames.profileSetup;
          }
          // User is authenticated and profile is complete
          return null;
        },
        loading: () => RouteNames.splash,
        error: (_, _) => RouteNames.login,
      );
    }

    // Check if user is trying to access auth pages while already logged in
    final authRoutes = [
      RouteNames.login,
      RouteNames.register,
      RouteNames.forgotPassword,
    ];

    if (authRoutes.contains(state.uri.toString())) {
      return authState.when(
        data: (user) => user != null ? RouteNames.dashboard : null,
        loading: () => null,
        error: (_, _) => null,
      );
    }

    return null;
  }

  static bool isProtectedRoute(String location) {
    final protectedRoutes = [
      RouteNames.createArticle,
      RouteNames.drafts,
      RouteNames.publishPreview,
      RouteNames.profile,
      RouteNames.editProfile,
      RouteNames.myArticles,
      RouteNames.savedArticles,
      RouteNames.settings,
      RouteNames.themeSettings,
      RouteNames.languageSettings,
      RouteNames.notificationSettings,
    ];

    return protectedRoutes.any((route) => location.startsWith(route));
  }

  static bool isAuthRoute(String location) {
    final authRoutes = [
      RouteNames.login,
      RouteNames.register,
      RouteNames.forgotPassword,
      RouteNames.profileSetup,
    ];

    return authRoutes.contains(location);
  }

  static bool requiresProfileSetup(String location) {
    final setupRequiredRoutes = [
      RouteNames.createArticle,
      RouteNames.profile,
      RouteNames.editProfile,
    ];

    return setupRequiredRoutes.any((route) => location.startsWith(route));
  }
}
