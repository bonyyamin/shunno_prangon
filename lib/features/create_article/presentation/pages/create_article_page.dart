// lib/features/create_article/presentation/pages/create_article_page.dart
import 'package:flutter/material.dart';

class CreateArticlePage extends StatelessWidget {
  
  const CreateArticlePage({super.key, this.articleId});
  final String? articleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Article')),
      body: const Center(child: Text('Article Editor - Coming Soon')),
    );
  }
}