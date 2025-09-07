// lib/features/discover/presentation/pages/discover_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';


class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                _buildSearchBar(context),
                const SizedBox(height: AppConstants.largePadding),
                _buildTabSection(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text('আবিষ্কার করুন'),
      floating: true,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            _showFilterBottomSheet(context);
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'প্রবন্ধ, লেখক বা বিষয় খুঁজুন...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
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
          tabs: const [
            Tab(text: 'বিষয়সমূহ'),
            Tab(text: 'জনপ্রিয়'),
            Tab(text: 'লেখকগণ'),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        SizedBox(
          height: 600, // Fixed height for TabBarView
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCategoriesTab(context),
              _buildTrendingTab(context),
              _buildAuthorsTab(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppConstants.defaultPadding,
        mainAxisSpacing: AppConstants.defaultPadding,
      ),
      itemCount: AppConstants.categories.length,
      itemBuilder: (context, index) {
        final category = AppConstants.categories[index];
        final categoryName = AppConstants.categoriesInBengali[category] ?? category;
        return _buildCategoryCard(context, category, categoryName, index);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category, String categoryName, int index) {
    final cosmic = context.cosmic;
    final categoryColor = cosmic.categoryColors[category] ?? Theme.of(context).colorScheme.primary;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to category articles using GoRouter
          GoRouter.of(context).go('${RouteNames.category}/${Uri.encodeComponent(category)}');
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoryColor.withValues(alpha: 0.1),
                categoryColor.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  categoryName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  '${(index + 1) * 12} প্রবন্ধ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTab(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 8,
      separatorBuilder: (context, index) => const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        return _buildTrendingArticleCard(context, index);
      },
    );
  }

  Widget _buildTrendingArticleCard(BuildContext context, int index) {
    final cosmic = context.cosmic;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to article detail
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: cosmic.cosmicGradient,
                  borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'জনপ্রিয় প্রবন্ধ ${index + 1}: কোয়ান্টাম বিশ্বের রহস্য',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(index + 1) * 1500} দর্শন',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '৮ মিনিট পড়া',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'পদার্থবিজ্ঞান',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cosmic.categoryColors['physics'],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorsTab(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppConstants.defaultPadding,
        mainAxisSpacing: AppConstants.defaultPadding,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildAuthorCard(context, index);
      },
    );
  }

  Widget _buildAuthorCard(BuildContext context, int index) {
    final cosmic = context.cosmic;
    
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: () {
          // Navigate to author profile
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: cosmic.stardustGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'ড. আকাশ গঙ্গা ${index + 1}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                '${(index + 1) * 5} প্রবন্ধ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                '${(index + 1) * 2}k অনুসরণকারী',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      builder: (context) => _buildFilterSheet(context),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ফিল্টার করুন',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'সময়ভিত্তিক',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: [
              'আজকে',
              'এই সপ্তাহে',
              'এই মাসে',
              'সকল সময়',
            ].map((filter) => ChoiceChip(
              label: Text(filter),
              selected: false,
              onSelected: (selected) {
                // Handle filter selection
              },
            )).toList(),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'পড়ার সময়',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            children: [
              '৫ মিনিট',
              '১০ মিনিট',
              '১৫+ মিনিট',
            ].map((filter) => ChoiceChip(
              label: Text(filter),
              selected: false,
              onSelected: (selected) {
                // Handle filter selection
              },
            )).toList(),
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
                    Navigator.pop(context);
                    // Apply filters
                  },
                  child: const Text('প্রয়োগ করুন'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}