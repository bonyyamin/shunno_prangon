// lib/features/discover/presentation/pages/category_page.dart
import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  
  const CategoryPage({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Category: $category')),
      body: Center(child: Text('Articles in category: $category')),
    );
  }
}