// lib/features/articles/presentation/pages/category_articles_page.dart
import 'package:flutter/material.dart';

class CategoryArticlesPage extends StatelessWidget {
  final String category;
  
  const CategoryArticlesPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Articles')),
      body: Center(child: Text('Articles in $category category')),
    );
  }
}