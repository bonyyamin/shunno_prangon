import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/router/route_names.dart';
import '../../../../../app/router/guards/onboarding_guard.dart';
import '../../../../../app/themes/theme_extensions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage(int numPages) {
    if (_currentPage < numPages - 1) {
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
    context.go(RouteNames.login);
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

    final List<Map<String, dynamic>> pages = [
      {
        'title': 'মহাকাশের রহস্য আবিষ্কার করুন',
        'description':
            'জ্যোতির্বিজ্ঞান, পদার্থবিজ্ঞান এবং মহাকাশ অনুসন্ধানের আকর্ষণীয় জগতে প্রবেশ করুন',
        'icon': Icons.explore,
        'gradient': [const Color(0xFF4B5B8B), const Color(0xFF789AD9)],
      },
      {
        'title': 'জ্ঞান ভাগাভাগি করুন',
        'description':
            'আপনার বৈজ্ঞানিক আবিষ্কার এবং চিন্তাভাবনা সবার সাথে শেয়ার করুন',
        'icon': Icons.share,
        'gradient': [const Color(0xFF789AD9), const Color(0xFFA2C7E7)],
      },
      {
        'title': 'একসাথে জানুন ও বুঝুন',
        'description':
            'বাংলা ভাষায় বিজ্ঞানের জটিল বিষয়গুলো সহজভাবে জানুন এবং বুঝুন',
        'icon': Icons.school,
        'gradient': [const Color(0xFFA2C7E7), const Color(0xFF4B5B8B)],
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: cosmic.nightSkyGradient),
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
                    child: const Text(
                      'এড়িয়ে যান',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(pages[index]);
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
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
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white70,
                            ),
                            label: const Text(
                              'পূর্ববর্তী',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : const SizedBox(width: 100),

                    // Next/Get Started button
                    ElevatedButton(
                      onPressed: () => _nextPage(pages.length),
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
                            _currentPage == pages.length - 1
                                ? 'শুরু করুন'
                                : 'পরবর্তী',
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

  Widget _buildOnboardingPage(Map<String, dynamic> page) {
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
                colors: page['gradient'] as List<Color>,
              ),
              boxShadow: [
                BoxShadow(
                  color: (page['gradient'] as List<Color>).first.withValues(
                    alpha: 0.3,
                  ),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              page['icon'] as IconData,
              size: 80,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            page['title'] as String,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Description
          Text(
            page['description'] as String,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
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
