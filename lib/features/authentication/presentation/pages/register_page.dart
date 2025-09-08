// lib/features/authentication/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/themes/theme_extensions.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('শর্তাবলী ও গোপনীয়তা নীতি গ্রহণ করুন')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🚀 Starting registration process...');
      print('📧 Email: ${_emailController.text}');
      print('👤 Display Name: ${_nameController.text}');

      final authNotifier = ref.read(authProvider.notifier);

      // Register user with Firebase
      await authNotifier.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      print('✅ Registration successful!');
      print('📤 Sending email verification...');

      // Send email verification
      try {
        await authNotifier.sendEmailVerification();
        print('✅ Email verification sent!');
      } catch (emailError) {
        print('❌ Email verification failed: $emailError');
        // Don't throw here, just log the error and continue
      }

      if (mounted) {
        setState(() => _isLoading = false);
        context.go(RouteNames.emailVerification);
      }
    } catch (error) {
      print('❌ Registration failed: $error');

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('নিবন্ধনে সমস্যা: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: ScaleTransition(
          scale: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.defaultPadding),

                // Header
                _buildHeader(theme),

                const SizedBox(height: AppConstants.largePadding),

                // Registration Form
                _buildRegistrationForm(theme),

                const SizedBox(height: AppConstants.defaultPadding),

                // Navigation Links
                _buildNavigationLinks(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.cosmic.cosmicGradient,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: const Icon(Icons.person_add, size: 40, color: Colors.white),
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        Text(
          'যোগ দিন', // "Join"
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: AppConstants.smallPadding),

        Text(
          'জ্ঞানের মহাকাশে আপনার যাত্রা শুরু করুন', // "Begin your journey in the cosmos of knowledge"
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.surface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegistrationForm(ThemeData theme) {
    return Card(
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
              Text(
                'নতুন অ্যাকাউন্ট তৈরি করুন', // "Create new account"
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Name Field
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'পূর্ণ নাম', // "Full name"
                  hintText: 'আপনার নাম লিখুন',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'নাম প্রয়োজন';
                  }
                  if (value!.length < 2) {
                    return 'নাম কমপক্ষে ২ অক্ষরের হতে হবে';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'ইমেইল', // "Email"
                  hintText: 'your@example.com',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'ইমেইল প্রয়োজন';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value!)) {
                    return 'বৈধ ইমেইল প্রবেশ করুন';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'পাসওয়ার্ড প্রয়োজন';
                  }
                  if (value!.length < 8) {
                    return 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';
                  }
                  if (!RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                  ).hasMatch(value)) {
                    return 'পাসওয়ার্ডে অন্তত একটি বড় হাতের অক্ষর, ছোট হাতের অক্ষর ও সংখ্যা থাকতে হবে';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Confirm Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleRegister(),
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড নিশ্চিত করুন', // "Confirm password"
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'পাসওয়ার্ড নিশ্চিত করুন';
                  }
                  if (value != _passwordController.text) {
                    return 'পাসওয়ার্ড মিলছে না';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Terms and Conditions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'আমি শর্তাবলী ও গোপনীয়তা নীতিতে সম্মত আছি', // "I agree to terms and privacy policy"
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Register Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('নিবন্ধন করুন'), // "Register"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationLinks(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ইতিমধ্যে অ্যাকাউন্ট আছে?', // "Already have an account?"
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.surface,
          ),
        ),
        TextButton(
          onPressed: () => context.go(RouteNames.login),
          child: Text(
            'লগইন করুন', // "Login"
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
