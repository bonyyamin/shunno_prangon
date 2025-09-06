// lib/features/articles/presentation/pages/article_list_page.dart
import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  String _sortBy = 'recent';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildFilterSection(context),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildTabSection(context),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to write article
          _showWriteOptions(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('প্রবন্ধসমূহ'),
      floating: true,
      pinned: true,
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            _showSortBottomSheet(context);
          },
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'বিষয়ভিত্তিক',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCategory = 'all';
                });
              },
              child: const Text('সব দেখুন'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCategoryChip('all', 'সব'),
              ...AppConstants.categories.map((category) {
                final categoryName = AppConstants.categoriesInBengali[category] ?? category;
                return _buildCategoryChip(category, categoryName);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, String label) {
    final isSelected = _selectedCategory == category;
    final cosmic = context.cosmic;
    final categoryColor = cosmic.categoryColors[category] ?? Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.smallPadding),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
        selectedColor: categoryColor.withValues(alpha: 0.2),
        checkmarkColor: categoryColor,
        labelStyle: TextStyle(
          color: isSelected ? categoryColor : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
      ),
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: Theme.of(context).colorScheme.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'সাম্প্রতিক'),
            Tab(text: 'জনপ্রিয়'),
            Tab(text: 'বিশেষ'),
            Tab(text: 'সংরক্ষিত'),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        SizedBox(
          height: 600, // Fixed height for TabBarView
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildArticlesList(context, 'recent'),
              _buildArticlesList(context, 'popular'),
              _buildArticlesList(context, 'featured'),
              _buildArticlesList(context, 'saved'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticlesList(BuildContext context, String type) {
    if (_isGridView) {
      return _buildArticlesGrid(context, type);
    } else {
      return _buildArticlesListView(context, type);
    }
  }

  Widget _buildArticlesListView(BuildContext context, String type) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return _buildArticleCard(context, index, type);
      },
    );
  }

  Widget _buildArticlesGrid(BuildContext context, String type) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.defaultPadding,
        mainAxisSpacing: AppConstants.defaultPadding,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildArticleGridCard(context, index, type);
      },
    );
  }

  Widget _buildArticleCard(BuildContext context, int index, String type) {
    final cosmic = context.cosmic;
    final categories = AppConstants.categories;
    final categoryIndex = index % categories.length;
    final category = categories[categoryIndex];
    final categoryName = AppConstants.categoriesInBengali[category] ?? category;
    final categoryColor = cosmic.categoryColors[category] ?? Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to article detail
          Navigator.pushNamed(context, '/article', arguments: 'article_$index');
        },
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
                      _getCategoryIcon(category),
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
                          _getArticleTitle(type, index),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Text(
                          'ড. বিজ্ঞানী ${index + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showArticleOptions(context, index);
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                _getArticleDescription(index),
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
                        '${5 + (index % 10)} মিনিট পড়া',
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
                        '${(index + 1) * 125}',
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

  Widget _buildArticleGridCard(BuildContext context, int index, String type) {
    final cosmic = context.cosmic;
    final categories = AppConstants.categories;
    final categoryIndex = index % categories.length;
    final category = categories[categoryIndex];
    final categoryName = AppConstants.categoriesInBengali[category] ?? category;
    final categoryColor = cosmic.categoryColors[category] ?? Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to article detail
          Navigator.pushNamed(context, '/article', arguments: 'article_$index');
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        _getCategoryIcon(category),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () {
                          // Toggle bookmark
                        },
                        icon: const Icon(
                          Icons.bookmark_outline,
                          color: Colors.white,
                        ),
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getArticleTitle(type, index),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        categoryName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${5 + (index % 10)} মি',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${(index + 1) * 125}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getArticleTitle(String type, int index) {
    switch (type) {
      case 'recent':
        return 'সাম্প্রতিক আবিষ্কার ${index + 1}: মহাকাশের নতুন রহস্য';
      case 'popular':
        return 'জনপ্রিয় ${index + 1}: কৃষ্ণগহ্বরের গভীর রহস্য';
      case 'featured':
        return 'বিশেষ প্রবন্ধ ${index + 1}: কোয়ান্টাম জগতের সন্ধানে';
      case 'saved':
        return 'সংরক্ষিত ${index + 1}: নক্ষত্রের জন্ম ও মৃত্যু';
      default:
        return 'প্রবন্ধ ${index + 1}: বিজ্ঞানের নতুন দিগন্ত';
    }
  }

  String _getArticleDescription(int index) {
    final descriptions = [
      'মহাকাশ বিজ্ঞানের সাম্প্রতিক আবিষ্কারগুলি আমাদের মহাবিশ্ব সম্পর্কে নতুন দৃষ্টিভঙ্গি দিয়েছে। এই প্রবন্ধে আমরা আলোচনা করব...',
      'কৃষ্ণগহ্বরের আশেপাশে সময় ও স্থানের বিকৃতি কিভাবে ঘটে এবং এর বৈজ্ঞানিক ব্যাখ্যা কী তা নিয়ে বিস্তারিত আলোচনা...',
      'কোয়ান্টাম বলবিদ্যার মূল নীতিগুলি এবং এটি কিভাবে আমাদের দৈনন্দিন জীবনে প্রভাব ফেলছে সে সম্পর্কে জানুন...',
      'নক্ষত্রদের জীবনচক্র থেকে শুরু করে সুপারনোভা বিস্ফোরণ পর্যন্ত - মহাকাশের এই রোমাঞ্চকর যাত্রায় অংশগ্রহণ করুন...',
      'আধুনিক পদার্থবিজ্ঞানের সবচেয়ে রহস্যময় বিষয়গুলি নিয়ে গবেষণা এবং এর ভবিষ্যৎ সম্ভাবনা সম্পর্কে জানুন...',
    ];
    return descriptions[index % descriptions.length];
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'astronomy':
        return Icons.star_border;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.biotech;
      case 'space_exploration':
        return Icons.rocket_launch;
      case 'cosmology':
        return Icons.public;
      case 'astrophysics':
        return Icons.star;
      case 'particle_physics':
        return Icons.scatter_plot;
      case 'quantum_mechanics':
        return Icons.psychology;
      case 'general_science':
        return Icons.school;
      default:
        return Icons.article;
    }
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => _buildSortSheet(context),
    );
  }

  Widget _buildSortSheet(BuildContext context) {
    final sortOptions = [
      {'key': 'recent', 'label': 'সাম্প্রতিক'},
      {'key': 'popular', 'label': 'জনপ্রিয়তা'},
      {'key': 'oldest', 'label': 'পুরাতন'},
      {'key': 'alphabetical', 'label': 'বর্ণানুক্রমিক'},
    ];

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'সাজানোর ধরন',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...sortOptions.map((option) => RadioListTile<String>(
            title: Text(option['label']!),
            value: option['key']!,
            groupValue: _sortBy,
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }

  void _showWriteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('নতুন প্রবন্ধ লিখুন'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to write article
              },
            ),
            ListTile(
              leading: const Icon(Icons.drafts),
              title: const Text('খসড়া থেকে চালিয়ে যান'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to drafts
              },
            ),
            ListTile(
              leading: const Icon(Icons.import_contacts),
              title: const Text('টেমপ্লেট ব্যবহার করুন'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to templates
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showArticleOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_outline),
              title: const Text('সংরক্ষণ করুন'),
              onTap: () {
                Navigator.pop(context);
                // Save article
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('শেয়ার করুন'),
              onTap: () {
                Navigator.pop(context);
                // Share article
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('ডাউনলোড করুন'),
              onTap: () {
                Navigator.pop(context);
                // Download article
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('রিপোর্ট করুন'),
              onTap: () {
                Navigator.pop(context);
                // Report article
              },
            ),
          ],
        ),
      ),
    );
  }
}