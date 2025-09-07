// lib/features/articles/presentation/pages/category_articles_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';

class CategoryArticlesPage extends StatefulWidget {
  const CategoryArticlesPage({super.key, required this.category});
  final String category;

  @override
  State<CategoryArticlesPage> createState() => _CategoryArticlesPageState();
}

class _CategoryArticlesPageState extends State<CategoryArticlesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'recent';
  bool _isGridView = false;
  String _selectedSubCategory = 'all';

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

  String get categoryNameBn => 
      AppConstants.categoriesInBengali[widget.category] ?? widget.category;

  @override
  Widget build(BuildContext context) {
    final cosmic = context.cosmic;
    final categoryColor = cosmic.categoryColors[widget.category] ?? 
                         Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, cosmic, categoryColor),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCategoryInfo(context, cosmic, categoryColor),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildSubCategoriesFilter(context, cosmic, categoryColor),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildTabSection(context),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWriteArticleDialog(context, categoryColor);
        },
        backgroundColor: categoryColor,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CosmicThemeExtension cosmic, Color categoryColor) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Navigate back to dashboard with index 2 (articles list)
          context.go('${RouteNames.dashboard}?tab=2');
        },
      ),
      title: Text(categoryNameBn),
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
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            _showFilterBottomSheet(context, cosmic);
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [categoryColor, categoryColor.withValues(alpha: 0.7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(widget.category),
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                categoryNameBn,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(BuildContext context, CosmicThemeExtension cosmic, Color categoryColor) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: Icon(
                    _getCategoryIcon(widget.category),
                    color: categoryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryNameBn,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '১২৮ টি প্রবন্ধ • ৫.২k পাঠক',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // Follow category
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: categoryColor),
                    foregroundColor: categoryColor,
                  ),
                  child: const Text('অনুসরণ করুন'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              _getCategoryDescription(widget.category),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                _buildStatChip(context, Icons.article, '১২৮ প্রবন্ধ'),
                const SizedBox(width: AppConstants.smallPadding),
                _buildStatChip(context, Icons.people, '৫.২k পাঠক'),
                const SizedBox(width: AppConstants.smallPadding),
                _buildStatChip(context, Icons.trending_up, '৮৫% বৃদ্ধি'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoriesFilter(BuildContext context, CosmicThemeExtension cosmic, Color categoryColor) {
    final subCategories = _getSubCategories(widget.category);
    
    if (subCategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'উপবিভাগ',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSubCategoryChip('all', 'সব', categoryColor),
              ...subCategories.map((subCategory) =>
                _buildSubCategoryChip(subCategory['key']!, subCategory['label']!, categoryColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubCategoryChip(String key, String label, Color categoryColor) {
    final isSelected = _selectedSubCategory == key;
    
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.smallPadding),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedSubCategory = key;
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
            Tab(text: 'শীর্ষ রেটেড'),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        SizedBox(
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildArticlesList(context, 'recent'),
              _buildArticlesList(context, 'popular'),
              _buildArticlesList(context, 'featured'),
              _buildArticlesList(context, 'top_rated'),
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
      itemCount: 15,
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
      itemCount: 15,
      itemBuilder: (context, index) {
        return _buildArticleGridCard(context, index, type);
      },
    );
  }

  Widget _buildArticleCard(BuildContext context, int index, String type) {
    final cosmic = context.cosmic;
    final categoryColor = cosmic.categoryColors[widget.category] ?? 
                         Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () => context.go(
            RouteNames.articleDetail,
            extra: '${widget.category}_$index',
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
                      _getCategoryIcon(widget.category),
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
                          'ড. ${categoryNameBn} বিশেষজ্ঞ ${index + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              '${4.0 + (index % 10) * 0.1}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: AppConstants.smallPadding),
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${5 + (index % 10)} মিনিট',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
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
                          categoryNameBn,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: categoryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        '${DateTime.now().subtract(Duration(days: index)).day} জানু',
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
                      Icon(
                        Icons.favorite_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(index + 1) * 12}',
                        style: Theme.of(context).textTheme.bodySmall,
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
    final categoryColor = cosmic.categoryColors[widget.category] ?? 
                         Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/article', arguments: '${widget.category}_$index');
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
                        _getCategoryIcon(widget.category),
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(
                              '${4.0 + (index % 10) * 0.1}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
                        'ড. বিশেষজ্ঞ ${index + 1}',
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
                          Row(
                            children: [
                              Icon(Icons.visibility, size: 12),
                              const SizedBox(width: 2),
                              Text(
                                '${(index + 1) * 125}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
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
    final categoryTitles = {
      'astronomy': [
        'নক্ষত্রের জন্ম ও মৃত্যুর রহস্য',
        'গ্যালাক্সির কেন্দ্রে কৃষ্ণগহ্বর',
        'মহাকাশের প্রসারণ ও ডার্ক এনার্জি',
        'এক্সোপ্ল্যানেট আবিষ্কারের নতুন দিগন্ত',
      ],
      'physics': [
        'কোয়ান্টাম বিশ্বের অদ্ভুত নিয়মাবলী',
        'আইনস্টাইনের আপেক্ষিকতার তত্ত্ব',
        'হিগস বোসন কণার আবিষ্কার',
        'পদার্থের চতুর্থ অবস্থা প্লাজমা',
      ],
      'chemistry': [
        'রাসায়নিক বিক্রিয়ার গতিবিদ্যা',
        'জৈব রসায়নের মৌলিক নীতি',
        'ক্যাটালিস্টের ভূমিকা ও প্রয়োগ',
        'আণবিক গঠন ও বন্ধন',
      ],
    };
    
    final titles = categoryTitles[widget.category] ?? [
      '${categoryNameBn}ে নতুন আবিষ্কার',
      '${categoryNameBn}ের মৌলিক নীতি',
      '${categoryNameBn}ের প্রায়োগিক দিক',
      '${categoryNameBn}ের ভবিষ্যৎ',
    ];
    
    final typePrefix = {
      'recent': 'সাম্প্রতিক: ',
      'popular': 'জনপ্রিয়: ',
      'featured': 'বিশেষ: ',
      'top_rated': 'শীর্ষ রেটেড: ',
    };
    
    return (typePrefix[type] ?? '') + titles[index % titles.length];
  }

  String _getArticleDescription(int index) {
    final descriptions = [
      '${categoryNameBn}ের এই বিষয়টি নিয়ে গভীর আলোচনা এবং বিশ্লেষণ। নতুন গবেষণার ফলাফল এবং এর প্রভাব সম্পর্কে জানুন।',
      'বিজ্ঞানের এই শাখায় সাম্প্রতিক উন্নয়ন এবং ভবিষ্যতের সম্ভাবনা নিয়ে বিস্তারিত আলোচনা।',
      '${categoryNameBn}ের মৌলিক ধারণা থেকে শুরু করে জটিল বিষয়গুলির সহজ ব্যাখ্যা।',
      'এই ক্ষেত্রের বিশেষজ্ঞদের মতামত এবং গবেষণার সর্বশেষ অগ্রগতি সম্পর্কে জানুন।',
    ];
    return descriptions[index % descriptions.length];
  }

  List<Map<String, String>> _getSubCategories(String category) {
    switch (category) {
      case 'astronomy':
        return [
          {'key': 'stars', 'label': 'নক্ষত্র'},
          {'key': 'planets', 'label': 'গ্রহ'},
          {'key': 'galaxies', 'label': 'গ্যালাক্সি'},
          {'key': 'black_holes', 'label': 'কৃষ্ণগহ্বর'},
        ];
      case 'physics':
        return [
          {'key': 'quantum', 'label': 'কোয়ান্টাম'},
          {'key': 'relativity', 'label': 'আপেক্ষিকতা'},
          {'key': 'thermodynamics', 'label': 'তাপগতিবিদ্যা'},
          {'key': 'mechanics', 'label': 'বলবিদ্যা'},
        ];
      case 'chemistry':
        return [
          {'key': 'organic', 'label': 'জৈব রসায়ন'},
          {'key': 'inorganic', 'label': 'অজৈব রসায়ন'},
          {'key': 'physical', 'label': 'ভৌত রসায়ন'},
          {'key': 'analytical', 'label': 'বিশ্লেষণী রসায়ন'},
        ];
      default:
        return [];
    }
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'astronomy':
        return 'মহাকাশ ও মহাবিশ্বের রহস্য উন্মোচন। নক্ষত্র, গ্রহ, গ্যালাক্সি এবং কৃষ্ণগহ্বর নিয়ে গবেষণা ও আবিষ্কার।';
      case 'physics':
        return 'পদার্থবিজ্ঞানের মৌলিক নীতি থেকে আধুনিক কোয়ান্টাম তত্ত্ব পর্যন্ত সবকিছু।';
      case 'chemistry':
        return 'রাসায়নিক বিক্রিয়া, আণবিক গঠন এবং পদার্থের ধর্ম নিয়ে বিস্তারিত আলোচনা।';
      case 'space_exploration':
        return 'মানুষের মহাকাশ অভিযান, রকেট প্রযুক্তি এবং ভবিষ্যতের মিশন সম্পর্কে।';
      default:
        return '${categoryNameBn}ের বিভিন্ন বিষয় নিয়ে গবেষণা এবং আলোচনা।';
    }
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
      {'key': 'recent', 'label': 'সাম্প্রতিক', 'icon': Icons.new_releases_outlined},
      {'key': 'popular', 'label': 'জনপ্রিয়', 'icon': Icons.trending_up},
      {'key': 'top_rated', 'label': 'শীর্ষ রেটেড', 'icon': Icons.star_outline},
      {'key': 'most_viewed', 'label': 'সর্বাধিক পঠিত', 'icon': Icons.visibility_outlined},
    ];

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'প্রবন্ধ সাজান',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...sortOptions.map((option) {
            final isSelected = _sortBy == option['key'];
            return ListTile(
              leading: Icon(option['icon'] as IconData),
              title: Text(option['label'] as String),
              trailing: isSelected ? const Icon(Icons.check_circle) : null,
              onTap: () {
                setState(() {
                  _sortBy = option['key'] as String;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, CosmicThemeExtension cosmic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => _buildFilterSheet(context, cosmic),
    );
  }

  Widget _buildFilterSheet(BuildContext context, CosmicThemeExtension cosmic) {
    // Dummy data for filters
    final readingTimes = ['যেকোনো', '< ৫ মিনিট', '৫-১০ মিনিট', '> ১০ মিনিট'];
    final articleTypes = ['সকল', 'সাধারণ', 'বিশেষ', 'টিউটোরিয়াল'];
    String selectedTime = readingTimes[0];
    String selectedType = articleTypes[0];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: ListView(
          controller: controller,
          children: [
            Text(
              'ফিল্টার',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildFilterSection(
              context,
              'পড়ার সময়',
              readingTimes,
              selectedTime,
              (value) {
                // setState(() => selectedTime = value);
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildFilterSection(
              context,
              'প্রবন্ধের ধরণ',
              articleTypes,
              selectedType,
              (value) {
                // setState(() => selectedType = value);
              },
            ),
            const SizedBox(height: AppConstants.largePadding),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('বাতিল'),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Apply filters
                      Navigator.pop(context);
                    },
                    child: const Text('প্রয়োগ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    String title,
    List<String> options,
    String selectedValue,
    ValueChanged<String> onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Wrap(
          spacing: AppConstants.smallPadding,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showWriteArticleDialog(BuildContext context, Color categoryColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('নতুন প্রবন্ধ লিখুন'),
          content: Text('আপনি কি "${categoryNameBn}" বিভাগে একটি নতুন প্রবন্ধ লিখতে চান?'),
          actions: <Widget>[
            TextButton(
              child: const Text('না'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: categoryColor,
              ),
              child: const Text('হ্যাঁ, লিখুন'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/create_article', arguments: widget.category);
              },
            ),
          ],
        );
      },
    );
  }

  void _showArticleOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.bookmark_add_outlined),
              title: const Text('সংরক্ষণ করুন'),
              onTap: () {
                Navigator.pop(context);
                // Handle save
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('শেয়ার করুন'),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('রিপোর্ট করুন'),
              onTap: () {
                Navigator.pop(context);
                // Handle report
              },
            ),
          ],
        );
      },
    );
  }
}
