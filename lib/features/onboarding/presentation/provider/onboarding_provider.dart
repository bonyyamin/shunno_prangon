// lib/shared/providers/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    // Load from shared preferences
    // For demo purposes, we'll start with false
    state = false;
  }

  Future<void> completeOnboarding() async {
    state = true;
    // Save to shared preferences
    // await _saveOnboardingStatus(true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    // Save to shared preferences
    // await _saveOnboardingStatus(false);
  }

  // Future<void> _saveOnboardingStatus(bool completed) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboarding_completed', completed);
  // }
}