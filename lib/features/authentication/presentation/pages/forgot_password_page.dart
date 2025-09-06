// lib/features/authentication/presentation/pages/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/themes/theme_extensions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate sending reset email
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        title: const Text('পাসওয়ার্ড রিসেট'), // "Password Reset"
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(RouteNames.login),
        ),
      ),
      body: SafeArea(
        child: ScaleTransition(
          scale: _bounceAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.extraLargePadding),
      
                if (!_emailSent) ...[
                  _buildResetForm(theme),
                ] else ...[
                  _buildSuccessMessage(theme),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm(ThemeData theme) {
    return Column(
      children: [
        // Icon and Title
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.cosmic.cosmicGradient,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(Icons.lock_reset, size: 60, color: Colors.white),
        ),

        const SizedBox(height: AppConstants.largePadding),

        Text(
          'পাসওয়ার্ড ভুলে গেছেন?', // "Forgot Password?"
          style: theme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: AppConstants.smallPadding),

        Text(
          'চিন্তা নেই! আপনার ইমেইল ঠিকানা দিন এবং আমরা আপনাকে পাসওয়ার্ড রিসেট করার লিঙ্ক পাঠিয়ে দেব।',
          // "Don't worry! Enter your email address and we'll send you a password reset link."
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.extraLargePadding),

        // Reset Form
        Card(
          elevation: AppConstants.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSendResetEmail(),
                    decoration: const InputDecoration(
                      labelText: 'ইমেইল ঠিকানা', // "Email Address"
                      hintText: 'your@example.com',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: AuthValidators.validateEmail,
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleSendResetEmail,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: Text(
                        _isLoading ? 'পাঠানো হচ্ছে...' : 'রিসেট লিঙ্ক পাঠান',
                      ),
                      // "Sending..." : "Send Reset Link"
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.largePadding),

        TextButton(
          onPressed: () => context.go(RouteNames.login),
          child: const Text(
            'লগইন পেজে ফিরে যান', // "Back to Login"
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessMessage(ThemeData theme) {
    return Column(
      children: [
        // Icon and Title
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.cosmic.cosmicGradient,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 60,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: AppConstants.largePadding),

        Text(
          'ইমেইল পাঠানো হয়েছে!', // "Email Sent!"
          style: theme.textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: AppConstants.smallPadding),

        Text(
          '${_emailController.text} এ আমরা একটি পাসওয়ার্ড রিসেট লিঙ্ক পাঠিয়েছি.',
          // "We've sent a password reset link to ..."
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.smallPadding),

        Text(
          'যদি ইমেইলটি না পান, তাহলে স্প্যাম ফোল্ডার চেক করুন.',
          // "If you don't see the email, check your spam folder."
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppConstants.extraLargePadding),

        SizedBox(
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () => context.go(RouteNames.login),
            icon: const Icon(Icons.arrow_back),
            label: const Text('লগইন পেজে ফিরে যান'), // "Back to Login"
          ),
        ),
      ],
    );
  }
}

class AuthValidators {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'ইমেইল প্রয়োজন';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
      return 'বৈধ ইমেইল প্রবেশ করুন';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'পাসওয়ার্ড প্রয়োজন';
    }
    if (value!.length < 8) {
      return 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'পাসওয়ার্ডে অন্তত একটি বড় হাতের অক্ষর, ছোট হাতের অক্ষর ও সংখ্যা থাকতে হবে';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'নাম প্রয়োজন';
    }
    if (value!.length < 2) {
      return 'নাম কমপক্ষে ২ অক্ষরের হতে হবে';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value?.isEmpty ?? true) {
      return 'পাসওয়ার্ড নিশ্চিত করুন';
    }
    if (value != password) {
      return 'পাসওয়ার্ড মিলছে না';
    }
    return null;
  }
}
