// lib/features/articles/presentation/pages/article_detail_page.dart
import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  
  const ArticleDetailPage({super.key, required this.articleId});
  final String articleId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: Center(child: Text('Article ID: $articleId')),
    );
  }
}