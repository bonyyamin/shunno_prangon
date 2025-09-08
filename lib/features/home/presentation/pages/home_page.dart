// lib/features/home/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';
import 'package:shunno_prangon/features/create_article/presentation/pages/create_article_page.dart';
import 'package:shunno_prangon/features/profile/presentation/pages/saved_articles_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                _buildWelcomeCard(context),
                const SizedBox(height: AppConstants.defaultPadding),
                _buildQuickActions(context),
                const SizedBox(height: AppConstants.largePadding),
                _buildFeaturedSection(context),
                const SizedBox(height: AppConstants.largePadding),
                _buildRecentArticles(context),
                const SizedBox(height: AppConstants.largePadding),
                _buildTrendingCategories(context),
                const SizedBox(height: AppConstants.extraLargePadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final cosmic = context.cosmic;

    return SliverAppBar(
      expandedHeight: 200.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appNameBn,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            Text(AppConstants.appMottoBn, style: TextStyle(fontSize: 12)),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(gradient: cosmic.nightSkyGradient),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: StarsPainter())),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Navigate to search page
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Navigate to notifications
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final cosmic = context.cosmic;

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: cosmic.stardustGradient,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, size: 32, color: Color(0xFF4B5B8B)),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'মহাকাশে স্বাগতম!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A202D),
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  'আজকের নতুন আবিষ্কার এবং বৈজ্ঞানিক প্রবন্ধ পড়ুন',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4B5B8B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.create_outlined,
            title: 'লিখুন',
            subtitle: 'নতুন প্রবন্ধ',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const CreateArticlePage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.bookmark_outline,
            title: 'সংরক্ষিত',
            subtitle: 'পরে পড়ুন',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const SavedArticlesPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'বিশেষ প্রবন্ধ',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all featured articles
              },
              child: const Text('সব দেখুন'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildFeaturedCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(BuildContext context, int index) {
    final cosmic = context.cosmic;

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: AppConstants.defaultPadding),
      child: Card(
        elevation: AppConstants.cardElevation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          child: Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(gradient: cosmic.cosmicGradient),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'কৃষ্ণগহ্বরের রহস্য ${index + 1}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'বিজ্ঞানী • ২ ঘন্টা আগে',
                        style: Theme.of(context).textTheme.bodySmall,
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

  Widget _buildRecentArticles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'সাম্প্রতিক প্রবন্ধ',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all recent articles
              },
              child: const Text('সব দেখুন'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppConstants.defaultPadding),
          itemBuilder: (context, index) {
            return _buildArticleCard(context, index);
          },
        ),
      ],
    );
  }

  Widget _buildArticleCard(BuildContext context, int index) {
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: context.cosmic.cosmicGradient,
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallBorderRadius,
                  ),
                ),
                child: const Icon(Icons.article, color: Colors.white),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'মহাকাশে জীবনের সন্ধান ${index + 1}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'জ্যোতির্বিদ্যা • ৫ মিনিট পড়া',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.bookmark_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'জনপ্রিয় বিষয়',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Wrap(
          spacing: AppConstants.smallPadding,
          runSpacing: AppConstants.smallPadding,
          children: AppConstants.categories.map((category) {
            final categoryName =
                AppConstants.categoriesInBengali[category] ?? category;
            return Chip(
              label: Text(categoryName),
              onDeleted: () {
                // Navigate to category
              },
              deleteIcon: const Icon(Icons.arrow_forward_ios, size: 16),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Custom painter for stars background
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Draw stars at random positions
    final stars = [
      Offset(size.width * 0.1, size.height * 0.2),
      Offset(size.width * 0.8, size.height * 0.1),
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.9, size.height * 0.4),
      Offset(size.width * 0.2, size.height * 0.9),
    ];

    for (final star in stars) {
      canvas.drawCircle(star, 2, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
