import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/shared/providers/locale_provider.dart';

class SelectLanguageScreen extends ConsumerWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(localeProvider.notifier).setEnglish();
                context.go(RouteNames.onboarding);
              },
              child: const Text('English'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(localeProvider.notifier).setBengali();
                context.go(RouteNames.onboarding);
              },
              child: const Text('বাংলা'),
            ),
          ],
        ),
      ),
    );
  }
}
