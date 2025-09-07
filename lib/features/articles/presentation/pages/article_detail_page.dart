// lib/features/articles/presentation/pages/article_detail_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';
import 'package:shunno_prangon/app/router/route_names.dart';
import 'package:shunno_prangon/app/themes/theme_extensions.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.articleId});
  final String articleId;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool _isBookmarked = false;
  bool _isLiked = false;
  int _likeCount = 125;
  double _fontSize = 16.0;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showAppBar) {
      setState(() {
        _showAppBar = true;
      });
    } else if (_scrollController.offset <= 200 && _showAppBar) {
      setState(() {
        _showAppBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cosmic = context.cosmic;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context, cosmic),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArticleHeader(context, cosmic),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildArticleContent(context),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildTagsSection(context, cosmic),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildAuthorSection(context, cosmic),
                  const SizedBox(height: AppConstants.largePadding),
                  _buildRelatedArticles(context, cosmic),
                  const SizedBox(height: AppConstants.extraLargePadding),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, cosmic),
      floatingActionButton: _buildFloatingActionButtons(context, cosmic),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _buildAppBar(BuildContext context, CosmicThemeExtension cosmic) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go(
          RouteNames.articleList,
        ), // This will show Dashboard with articles tab
      ),
      title: _showAppBar ? const Text('প্রবন্ধ') : null,
      actions: [
        IconButton(
          icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_outline),
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showShareBottomSheet(context),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptionsBottomSheet(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(gradient: cosmic.cosmicGradient),
          child: const Center(
            child: Icon(Icons.article, size: 80, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildArticleHeader(
    BuildContext context,
    CosmicThemeExtension cosmic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.smallPadding,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: cosmic.categoryColors['physics']?.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'পদার্থবিজ্ঞান',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cosmic.categoryColors['physics'],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '৮ মিনিট পড়া',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Icon(
                  Icons.visibility,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '১,২৫০ দর্শন',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Text(
          'কোয়ান্টাম বিশ্বের রহস্য: অসীম সম্ভাবনার জগত',
          style: Theme.of(
            context,
          ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Text(
          'কোয়ান্টাম পদার্থবিজ্ঞানের রহস্যময় জগতে আমাদের স্বাগতম। এই প্রবন্ধে আমরা জানব কিভাবে কণাগুলি একই সময়ে বিভিন্ন অবস্থানে থাকতে পারে এবং কিভাবে পর্যবেক্ষণ তাদের আচরণ পরিবর্তন করে দেয়।',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontStyle: FontStyle.italic,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: cosmic.categoryColors['physics'],
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ড. কোয়ান্টাম আহমেদ',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '১৫ জানুয়ারি, ২০২৪',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Follow author
              },
              child: const Text('অনুসরণ করুন'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'প্রবন্ধ',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _fontSize > 12
                      ? () {
                          setState(() {
                            _fontSize = (_fontSize - 2).clamp(12.0, 24.0);
                          });
                        }
                      : null,
                ),
                Text('Aa', style: TextStyle(fontSize: _fontSize)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _fontSize < 24
                      ? () {
                          setState(() {
                            _fontSize = (_fontSize + 2).clamp(12.0, 24.0);
                          });
                        }
                      : null,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        _buildContentSection(
          context,
          'ভূমিকা',
          'কোয়ান্টাম পদার্থবিজ্ঞান হলো পদার্থবিজ্ঞানের এমন একটি শাখা যা আমাদের দৈনন্দিন অভিজ্ঞতার সম্পূর্ণ বিপরীত আচরণ প্রদর্শন করে। এই জগতে কণাগুলি একই সময়ে একাধিক স্থানে অবস্থান করতে পারে, দূরত্ব নির্বিশেষে তাৎক্ষণিকভাবে একে অপরের সাথে যোগাযোগ করতে পারে এবং পর্যবেক্ষকের উপস্থিতিতে সম্পূর্ণ ভিন্ন আচরণ করতে পারে।',
        ),
        _buildContentSection(
          context,
          'সুপারপজিশনের নীতি',
          'কোয়ান্টাম সুপারপজিশন হলো কোয়ান্টাম বলবিদ্যার একটি মৌলিক নীতি। এই নীতি অনুযায়ী, একটি কোয়ান্টাম সিস্টেম একই সময়ে একাধিক কোয়ান্টাম অবস্থার সংমিশ্রণে থাকতে পারে। উদাহরণস্বরূপ, একটি ইলেকট্রন একই সময়ে ঘড়ির কাঁটার দিকে এবং বিপরীত দিকে ঘুরতে পারে। এই অবস্থাকে বলা হয় "সুপারপজিশন স্টেট"।',
        ),
        _buildContentSection(
          context,
          'কোয়ান্টাম এনট্যাঙ্গেলমেন্ট',
          'কোয়ান্টাম এনট্যাঙ্গেলমেন্ট হলো একটি রহস্যময় ঘটনা যেখানে দুটি বা ততোধিক কণা একটি বিশেষ সম্পর্কে আবদ্ধ হয়ে থাকে। এই অবস্থায়, একটি কণার অবস্থা পরিমাপ করলে তাৎক্ষণিকভাবে অন্য কণার অবস্থা নির্ধারিত হয়ে যায়, যত দূরেই তারা থাকুক না কেন। আইনস্টাইন একে "ভয়ানক দূরবর্তী ক্রিয়া" বলে অভিহিত করেছিলেন।',
        ),
        _buildContentSection(
          context,
          'অনিশ্চয়তার নীতি',
          'হাইজেনবার্গের অনিশ্চয়তার নীতি অনুযায়ী, আমরা একটি কণার অবস্থান এবং ভরবেগ একই সাথে নিখুঁতভাবে পরিমাপ করতে পারি না। এই নীতি প্রকৃতির একটি মৌলিক বৈশিষ্ট্য এবং এটি কোনো যন্ত্রের সীমাবদ্ধতার কারণে নয়। এই অনিশ্চয়তা কোয়ান্টাম জগতের একটি অন্তর্নিহিত বৈশিষ্ট্য।',
        ),
        _buildContentSection(
          context,
          'উপসংহার',
          'কোয়ান্টাম পদার্থবিজ্ঞান আমাদের বাস্তবতার উপলব্ধিকে সম্পূর্ণ বদলে দিয়েছে। এটি কম্পিউটার প্রযুক্তি, চিকিৎসা বিজ্ঞান এবং যোগাযোগ প্রযুক্তিতে বিপ্লব আনতে চলেছে। কোয়ান্টাম কম্পিউটিং, কোয়ান্টাম ক্রিপ্টোগ্রাফি এবং কোয়ান্টাম টেলিপোর্টেশনের মতো প্রযুক্তি আমাদের ভবিষ্যতকে আরও উন্নত এবং নিরাপদ করে তুলবে।',
        ),
      ],
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppConstants.defaultPadding),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          content,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: _fontSize, height: 1.6),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }

  Widget _buildTagsSection(BuildContext context, CosmicThemeExtension cosmic) {
    final tags = [
      'কোয়ান্টাম',
      'পদার্থবিজ্ঞান',
      'বিজ্ঞান',
      'প্রযুক্তি',
      'গবেষণা',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ট্যাগ',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Wrap(
          spacing: AppConstants.smallPadding,
          runSpacing: AppConstants.smallPadding,
          children: tags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  backgroundColor: cosmic.categoryColors['physics']?.withValues(
                    alpha: 0.1,
                  ),
                  labelStyle: TextStyle(
                    color: cosmic.categoryColors['physics'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildAuthorSection(
    BuildContext context,
    CosmicThemeExtension cosmic,
  ) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'লেখক সম্পর্কে',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: cosmic.categoryColors['physics'],
                  child: const Icon(
                    Icons.person,
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
                        'ড. কোয়ান্টাম আহমেদ',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'কোয়ান্টাম পদার্থবিজ্ঞানী',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cosmic.categoryColors['physics'],
                        ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Row(
                        children: [
                          Text(
                            '১৫ প্রবন্ধ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: AppConstants.defaultPadding),
                          Text(
                            '৫.২k অনুসরণকারী',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'ঢাকা বিশ্ববিদ্যালয়ের পদার্থবিজ্ঞান বিভাগের অধ্যাপক। কোয়ান্টাম কম্পিউটিং এবং কোয়ান্টাম ক্রিপ্টোগ্রাফির উপর গবেষণা করছেন। জটিল বৈজ্ঞানিক বিষয়গুলি সহজভাবে উপস্থাপনার জন্য পরিচিত।',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View profile
                    },
                    child: const Text('প্রোফাইল দেখুন'),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Follow author
                    },
                    child: const Text('অনুসরণ করুন'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedArticles(
    BuildContext context,
    CosmicThemeExtension cosmic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'সম্পর্কিত প্রবন্ধ',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppConstants.defaultPadding),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: Card(
                  elevation: AppConstants.cardElevation,
                  child: InkWell(
                    onTap: () {
                      // Navigate to related article
                    },
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultBorderRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.defaultBorderRadius,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: cosmic.cosmicGradient,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.science,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                AppConstants.smallPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'সম্পর্কিত প্রবন্ধ ${index + 1}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '৫ মিনিট পড়া',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, CosmicThemeExtension cosmic) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isLiked = !_isLiked;
                _likeCount += _isLiked ? 1 : -1;
              });
            },
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_outline,
              color: _isLiked ? Colors.red : null,
            ),
          ),
          Text('$_likeCount', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: AppConstants.defaultPadding),
          IconButton(
            onPressed: () {
              // Show comments
            },
            icon: const Icon(Icons.comment_outlined),
          ),
          Text('৮৫', style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showShareBottomSheet(context),
            icon: const Icon(Icons.share, size: 18),
            label: const Text('শেয়ার'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(
    BuildContext context,
    CosmicThemeExtension cosmic,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "bookmark",
          mini: true,
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
          },
          backgroundColor: _isBookmarked
              ? cosmic.categoryColors['physics']
              : Theme.of(context).colorScheme.surface,
          child: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
            color: _isBookmarked
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        FloatingActionButton(
          heroTag: "scroll_to_top",
          mini: true,
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ],
    );
  }

  void _showShareBottomSheet(BuildContext context) {
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
            Text(
              'শেয়ার করুন',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(context, Icons.link, 'লিংক কপি', () {}),
                _buildShareOption(context, Icons.facebook, 'Facebook', () {}),
                _buildShareOption(context, Icons.share, 'WhatsApp', () {}),
                _buildShareOption(context, Icons.email, 'Email', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
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
              leading: const Icon(Icons.download),
              title: const Text('অফলাইনের জন্য সংরক্ষণ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('ফন্ট সাইজ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('রিপোর্ট করুন'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
