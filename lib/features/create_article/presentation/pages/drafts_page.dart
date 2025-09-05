// lib/features/create_article/presentation/pages/drafts_page.dart
import 'package:flutter/material.dart';

class DraftsPage extends StatelessWidget {
  const DraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drafts')),
      body: const Center(child: Text('Draft Articles - Coming Soon')),
    );
  }
}