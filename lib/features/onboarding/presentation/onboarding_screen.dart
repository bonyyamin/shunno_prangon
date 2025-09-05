import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_names.dart';
import '../../../../../app/router/guards/onboarding_guard.dart';
import '../../../../../app/themes/theme_extensions.dart';
import '../../../../../l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      title: 'মহাকাশের রহস্য আবিষ্কার করুন',
      titleEn: 'Discover Cosmic Mysteries',
      description: 'জ্যোতির্বিজ্ঞান, পদার্থবিজ্ঞান এবং মহাকাশ অনুসন্ধানের বিস্ময়কর জগতে প্রবেশ করুন',
      descriptionEn: 'Dive into the fascinating world of astronomy, physics, and space exploration',
      icon: Icons.explore,
      gradient: [Color(0xFF4B5B8B), Color(0xFF789AD9)],
    ),
    OnboardingPage(
      title: 'জ্ঞান ভাগাভাগি করুন',
      titleEn: 'Share Knowledge',
      description: 'আপনার বৈজ্ঞানিক আবিষ্কার এবং চিন্তাভাবনা সবার সাথে শেয়ার করুন',
      descriptionEn: 'Share your scientific discoveries and thoughts with the community',
      icon: Icons.share,
      gradient: [Color(0xFF789AD9), Color(0xFFA2C7E7)],
    ),
    OnboardingPage(
      title: 'একসাথে শিখুন',
      titleEn: 'Learn Together',
      description: 'বাংলা ভাষায় বিজ্ঞানের জটিল বিষয়গুলো সহজভাবে বুঝুন এবং শেখান',
      descriptionEn: 'Understand and teach complex scientific topics in Bengali language',
      icon: Icons.school,
      gradient: [Color(0xFFA2C7E7), Color(0xFF4B5B8B)],
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    OnboardingGuard.completeOnboarding(ref);
    context.go(RouteNames.home);
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cosmic = context.cosmic;
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: cosmic.nightSkyGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      l10n.skip,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_pages[index]);
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),

              const SizedBox(height: 32),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    _currentPage > 0
                        ? TextButton.icon(
                            onPressed: _previousPage,
                            icon: const Icon(Icons.arrow_back, color: Colors.white70),
                            label: Text(
                              l10n.previous,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          )
                        : const SizedBox(width: 100),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: cosmic.nightSkyGradient.colors.first,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage == _pages.length - 1
                                ? 'শুরু করুন'
                                : l10n.next,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon with gradient background
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: page.gradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: page.gradient.first.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 48),

          // Bengali title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // English title
          Text(
            page.titleEn,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Bengali description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // English description
          Text(
            page.descriptionEn,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white60,
              height: 1.4,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 24.0 : 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white30,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final IconData icon;
  final List<Color> gradient;

  const OnboardingPage({
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.icon,
    required this.gradient,
  });
}