// lib/features/authentication/presentation/pages/email_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/themes/theme_extensions.dart';
import '../providers/auth_provider.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen>
    with SingleTickerProviderStateMixin {
  bool _isResending = false;
  bool _isChecking = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
    });

    try {
      print('📧 Resend Email: Starting resend process...');
      final authNotifier = ref.read(authProvider.notifier);
      await authNotifier.sendEmailVerification();
      print('📧 Resend Email: Resend successful!');

      if (mounted) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('যাচাইকরণ ইমেইল সফলভাবে পাঠানো হয়েছে'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      print('❌ Resend Email: Failed - $error');
      if (mounted) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ইমেইল পাঠাতে সমস্যা হয়েছে: ${error.toString()}'),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  Future<void> _checkEmailVerification() async {
    setState(() {
      _isChecking = true;
    });

    try {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;

      // Show a message that we're checking
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('যাচাইকরণের অবস্থা পরীক্ষা করা হচ্ছে...'),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      // Add a small delay to allow Firebase to update
      await Future.delayed(const Duration(seconds: 2));

      final authNotifier = ref.read(authProvider.notifier);
      final isVerified = await authNotifier.isEmailVerified();

      if (isVerified && mounted) {
        // Email is verified, show success message and sign out
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ইমেইল সফলভাবে যাচাইকরণ হয়েছে',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
            backgroundColor: colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        // Sign out the user first
        await authNotifier.signOut();
        // Brief delay to show the success message
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          context.go(RouteNames.login);
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ইমেইল এখনও যাচাইকরণ হয়নি',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
            backgroundColor: colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('যাচাইকরণ পরীক্ষায় সমস্যা: ${error.toString()}'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final authState = ref.watch(authProvider);
    final email = authState.maybeWhen(
      data: (user) => user?.email ?? '',
      orElse: () => '',
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go(RouteNames.login),
        ),
        title: Text(
          'ইমেইল যাচাইকরণ',
          style: textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.largePadding),

                // Header Icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: context.cosmic.cosmicGradient,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Title
                Text(
                  'আপনার ইমেইল যাচাই করুন',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Description
                Text(
                  'আমরা একটি যাচাইকরণ ইমেইল পাঠিয়েছি',
                  style: textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.smallPadding),

                // Email display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultBorderRadius,
                    ),
                    border: Border.all(
                      color: theme.colorScheme.surface.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    email,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.surface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Instructions
                Text(
                  'ইমেইলে পাঠানো লিঙ্কে ক্লিক করুন',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.surface,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.extraLargePadding),

                // Additional instructions
                Text(
                  'আপনি যদি ইমেইল পাননি, তাহলে আপনার স্প্যাম ফোল্ডার চেক করুন অথবা নিচের বাটনে ক্লিক করে যাচাইকরণ ইমেইল পুনরায় পাঠান।',
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppConstants.extraLargePadding),

                // Verify Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isChecking ? null : _checkEmailVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.largeBorderRadius,
                        ),
                      ),
                    ),
                    child: _isChecking
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'আমি আমার ইমেইল যাচাই করেছি',
                            style: textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Resend Button
                TextButton(
                  onPressed: _isResending ? null : _resendVerificationEmail,
                  child: _isResending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'যাচাইকরণ ইমেইল পুনরায় পাঠান',
                          style: textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Error message display
                authState.maybeWhen(
                  error: (error, _) => Container(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      error.toString(),
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Back to login
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text(
                    'লগইন পেজে ফিরে যান',
                    style: textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.surface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
