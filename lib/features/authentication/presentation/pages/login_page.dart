// lib/features/authentication/presentation/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/themes/theme_extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
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
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate login process
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go(RouteNames.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                const SizedBox(height: AppConstants.extraLargePadding),

                // Logo and Welcome Section
                _buildHeader(theme),

                const SizedBox(height: AppConstants.extraLargePadding),

                // Login Form
                _buildLoginForm(theme),

                const SizedBox(height: AppConstants.largePadding),

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
        // App Icon/Logo placeholder
        Container(
          width: 100,
          height: 100,
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
          child: const Icon(Icons.stars, size: 50, color: Colors.white),
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        Text(
          AppConstants.appNameBn,
          style: theme.textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: AppConstants.smallPadding),

        Text(
          'আপনার অ্যাকাউন্টে প্রবেশ করুন', // "Login to your account"
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
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
                'লগইন', // "Login"
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.largePadding),

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
                    return 'ইমেইল প্রয়োজন'; // "Email is required"
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value!)) {
                    return 'বৈধ ইমেইল প্রবেশ করুন'; // "Enter a valid email"
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleLogin(),
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড', // "Password"
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
                    return 'পাসওয়ার্ড প্রয়োজন'; // "Password is required"
                  }
                  if (value!.length < 6) {
                    return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে'; // "Password must be at least 6 characters"
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppConstants.defaultPadding),

              // Remember Me & Forgot Password
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'আমাকে মনে রাখুন', // "Remember me"
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go(RouteNames.forgotPassword),
                    child: Text(
                      'পাসওয়ার্ড ভুলে গেছেন?', // "Forgot password?"
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Login Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('লগইন করুন'), // "Login"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationLinks(ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'নতুন ব্যবহারকারী? ', // "New user? "
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
            ),
            TextButton(
              onPressed: () => context.go(RouteNames.register),
              child: Text(
                'নিবন্ধন করুন', // "Register"
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.smallPadding),

        TextButton(
          onPressed: () => context.go(RouteNames.dashboard),
          child: const Text(
            'অতিথি হিসেবে চালিয়ে যান', // "Continue as guest"
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
