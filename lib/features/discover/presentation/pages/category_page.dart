// lib/features/discover/presentation/pages/category_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.category});
  final String category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isGridView = false;
  final List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch articles for this category from an API
    _loadArticles();
  }

  void _loadArticles() {
    // Mock data - replace with actual API call
    setState(() {
      _articles.clear();
      for (int i = 0; i < 10; i++) {
        _articles.add({
          'id': 'article_$i',
          'title': '${widget.category} নিয়ে গবেষণা প্রবন্ধ #${i + 1}',
          'author': 'ড. গবেষক ${i + 1}',
          'description': 'এটি ${widget.category} বিষয়ক একটি নমুনা প্রবন্ধের বর্ণনা। এই প্রবন্ধে ${widget.category} সম্পর্কে বিস্তারিত আলোচনা করা হয়েছে।',
          'category': widget.category,
          'readTime': 5 + (i % 10),
          'views': (i + 1) * 100,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = AppConstants.categoriesInBengali[widget.category] ?? widget.category;
    final categoryColor = context.cosmic.categoryColors[widget.category] ?? Theme.of(context).colorScheme.primary;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: _isGridView ? _buildGridView(categoryColor) : _buildListView(categoryColor),
    );
  }

  Widget _buildListView(Color categoryColor) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _articles.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) => _buildArticleCard(context, _articles[index], categoryColor),
    );
  }

  Widget _buildGridView(Color categoryColor) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppConstants.defaultPadding,
        mainAxisSpacing: AppConstants.defaultPadding,
      ),
      itemCount: _articles.length,
      itemBuilder: (context, index) => _buildGridArticleCard(context, _articles[index], categoryColor),
    );
  }

  Widget _buildArticleCard(BuildContext context, Map<String, dynamic> article, Color categoryColor) {
    final categoryName = AppConstants.categoriesInBengali[article['category']] ?? article['category'];
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () => context.go(
          RouteNames.articleDetail,
          extra: article['id'],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                    ),
                    child: Icon(
                      _getCategoryIcon(article['category']),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['title'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          article['author'],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                article['description'],
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.smallPadding,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categoryName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article['readTime']} মিনিট পড়া',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article['views']}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      IconButton(
                        onPressed: () {
                          // Toggle bookmark
                        },
                        icon: const Icon(Icons.bookmark_outline),
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridArticleCard(BuildContext context, Map<String, dynamic> article, Color categoryColor) {
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () => context.go(
          RouteNames.articleDetail,
          extra: article['id'],
        ),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: Icon(
                    _getCategoryIcon(article['category']),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                article['title'],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                article['author'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${article['readTime']} মিনিট',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${article['views']}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'science':
        return Icons.science;
      case 'technology':
        return Icons.computer;
      case 'history':
        return Icons.history_edu;
      case 'literature':
        return Icons.menu_book;
      case 'philosophy':
        return Icons.psychology;
      case 'religion':
        return Icons.people;
      case 'culture':
        return Icons.palette;
      case 'politics':
        return Icons.gavel;
      case 'economics':
        return Icons.attach_money;
      case 'health':
        return Icons.health_and_safety;
      case 'education':
        return Icons.school;
      case 'environment':
        return Icons.eco;
      default:
        return Icons.article;
    }
  }
}