// lib/features/authentication/presentation/widgets/social_login_buttons.dart
import 'package:flutter/material.dart';
import '../../../../app/constants/app_constants.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
    this.onApplePressed,
    this.isLoading = false,
  });

  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onApplePressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: Text(
                'অথবা', // "Or"
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        Row(
          children: [
            // Google Login
            if (onGooglePressed != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onGooglePressed,
                  icon: Image.asset(
                    'assets/images/icons/google.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                ),
              ),

            if (onGooglePressed != null && (onFacebookPressed != null || onApplePressed != null))
              const SizedBox(width: AppConstants.smallPadding),

            // Facebook Login
            if (onFacebookPressed != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onFacebookPressed,
                  icon: Image.asset(
                    'assets/images/icons/facebook.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Facebook'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                ),
              ),

            if (onFacebookPressed != null && onApplePressed != null)
              const SizedBox(width: AppConstants.smallPadding),

            // Apple Login
            if (onApplePressed != null)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onApplePressed,
                  icon: Image.asset(
                    'assets/images/icons/apple.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text('Apple'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}