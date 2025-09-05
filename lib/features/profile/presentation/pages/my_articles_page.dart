// lib/features/profile/presentation/pages/my_articles_page.dart
import 'package:flutter/material.dart';

class MyArticlesPage extends StatelessWidget {
  const MyArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Articles')),
      body: const Center(child: Text('My Articles - Coming Soon')),
    );
  }
}