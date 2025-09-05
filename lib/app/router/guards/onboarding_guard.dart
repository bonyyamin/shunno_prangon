import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/features/onboarding/presentation/provider/onboarding_provider.dart';

class OnboardingGuard {
  static String? redirectLogic(GoRouterState state, Ref ref) {
    final hasCompletedOnboarding = ref.read(onboardingProvider);
    final currentLocation = state.uri.toString();

    // Routes that don't require onboarding completion
    final bypassRoutes = [RouteNames.splash, RouteNames.onboarding];

    // If user hasn't completed onboarding and is not on bypass routes
    if (!hasCompletedOnboarding && !bypassRoutes.contains(currentLocation)) {
      return RouteNames.onboarding;
    }

    // If user has completed onboarding and is trying to access onboarding
    if (hasCompletedOnboarding && currentLocation == RouteNames.onboarding) {
      return RouteNames.home;
    }

    return null;
  }

  static bool shouldShowOnboarding(WidgetRef ref) {
    return !ref.read(onboardingProvider);
  }

  static bool canAccessApp(WidgetRef ref) {
    return ref.read(onboardingProvider);
  }

  static void completeOnboarding(WidgetRef ref) {
    ref.read(onboardingProvider.notifier).completeOnboarding();
  }

  static void resetOnboarding(WidgetRef ref) {
    ref.read(onboardingProvider.notifier).resetOnboarding();
  }
}

// Provider for managing onboarding completion status
final onboardingStatusProvider =
    StateNotifierProvider<OnboardingStatusNotifier, bool>((ref) {
      return OnboardingStatusNotifier();
    });

class OnboardingStatusNotifier extends StateNotifier<bool> {
  OnboardingStatusNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    // Load from shared preferences or local storage
    // For now, we'll use a simple state management
    // In a real app, you'd load this from SharedPreferences
    state = false;
  }

  Future<void> completeOnboarding() async {
    state = true;
    // Save to shared preferences or local storage
    // await _saveOnboardingStatus(true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    // Save to shared preferences or local storage
    // await _saveOnboardingStatus(false);
  }

  // Future<void> _saveOnboardingStatus(bool completed) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboarding_completed', completed);
  // }
}
