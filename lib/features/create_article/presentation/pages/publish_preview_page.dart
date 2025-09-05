// lib/features/create_article/presentation/pages/publish_preview_page.dart
import 'package:flutter/material.dart';

class PublishPreviewPage extends StatelessWidget {
  
  const PublishPreviewPage({super.key, required this.articleId});
  final String articleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(child: Text('Preview for article: $articleId')),
    );
  }
}