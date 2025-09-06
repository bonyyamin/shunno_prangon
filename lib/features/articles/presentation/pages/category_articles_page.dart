// lib/features/articles/presentation/pages/category_articles_page.dart
import 'package:flutter/material.dart';

class CategoryArticlesPage extends StatelessWidget {
  
  const CategoryArticlesPage({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$category Articles')),
      body: Center(child: Text('Articles in $category category')),
    );
  }
}