// lib/features/discover/presentation/pages/search_results_page.dart
import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  
  const SearchResultsPage({super.key, required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search: $query')),
      body: Center(child: Text('Search results for: $query')),
    );
  }
}