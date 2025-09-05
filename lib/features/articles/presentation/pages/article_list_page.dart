// lib/features/articles/presentation/pages/article_list_page.dart
import 'package:flutter/material.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: const Center(child: Text('Article List - Coming Soon')),
    );
  }
}