import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/themes/theme_extensions.dart';
import '../../../../app/router/route_names.dart';

class PublishPreviewPage extends StatefulWidget {
  const PublishPreviewPage({super.key, required this.articleId});
  final String articleId;

  @override
  State<PublishPreviewPage> createState() => _PublishPreviewPageState();
}

class _PublishPreviewPageState extends State<PublishPreviewPage> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isPublishing = false;
  late final TabController _tabController;

  // Mock article data
  final ArticlePreview _article = ArticlePreview(
    title: 'ব্ল্যাক হোলের রহস্য: মহাকাশের সবচেয়ে রহস্যময় বস্তু',
    summary: 'ব্ল্যাক হোল কী এবং কীভাবে এগুলো গঠিত হয়? এই প্রবন্ধে আমরা জানবো ব্ল্যাক হোলের বৈজ্ঞানিক ব্যাখ্যা এবং মহাকাশে এর প্রভাব সম্পর্কে।',
    category: 'astronomy',
    content: '''# ব্ল্যাক হোলের রহস্য

ব্ল্যাক হোল মহাকাশের সবচেয়ে রহস্যময় এবং বিস্ময়কর বস্তুগুলোর মধ্যে একটি। এর মাধ্যাকর্ষণ এত প্রবল যে কোনো কিছুই, এমনকি আলোও এর থেকে বের হতে পারে না।

## ব্ল্যাক হোল কী?

ব্ল্যাক হোল হল মহাকাশের এমন একটি অঞ্চল যেখানে মাধ্যাকর্ষণের প্রভাব এত তীব্র যে কোনো কিছুই সেখান থেকে পালাতে পারে না। এমনকি আলোও নয়। এজন্যই এগুলোকে "কালো গহ্বর" বা ব্ল্যাক হোল বলা হয়।

### কীভাবে গঠিত হয়?

যখন একটি বিশাল নক্ষত্র তার জীবনের শেষ পর্যায়ে পৌঁছায়, তখন এর কেন্দ্রের পারমাণবিক জ্বালানি শেষ হয়ে যায়। এর ফলে নক্ষত্রটি নিজের মাধ্যাকর্ষণের কারণে সংকুচিত হতে থাকে এবং অবশেষে একটি ব্ল্যাক হোলে পরিণত হয়।

## ব্ল্যাক হোলের প্রকারভেদ

ব্ল্যাক হোল সাধারণত তিন ধরনের হয়ে থাকে:

1. **স্টেলার ব্ল্যাক হোল** - ছোট থেকে মাঝারি আকারের
2. **সুপারম্যাসিভ ব্ল্যাক হোল** - গ্যালাক্সির কেন্দ্রে অবস্থিত
3. **প্রাইমরডিয়াল ব্ল্যাক হোল** - মহাবিস্ফোরণের পর গঠিত

### ইভেন্ট হরাইজন

ব্ল্যাক হোলের চারপাশে একটি অদৃশ্য সীমানা রয়েছে যাকে ইভেন্ট হরাইজন বলা হয়। এই সীমানা পেরিয়ে গেলে আর ফেরত আসা সম্ভব নয়।

## আধুনিক গবেষণা

বর্তমানে বিজ্ঞানীরা ব্ল্যাক হোল নিয়ে নানা ধরনের গবেষণা চালিয়ে যাচ্ছেন। ইভেন্ট হরাইজন টেলিস্কোপের মাধ্যমে প্রথমবারের মতো একটি ব্ল্যাক হোলের ছবি তোলা সম্ভব হয়েছে।

## উপসংহার

ব্ল্যাক হোল আমাদের মহাবিশ্ব সম্পর্কে জানার ক্ষেত্রে অত্যন্ত গুরুত্বপূর্ণ। এর গবেষণা আমাদের পদার্থবিজ্ঞান ও জ্যোতির্বিদ্যার নতুন দিগন্ত উন্মোচন করে দিচ্ছে।''',
    tags: ['ব্ল্যাক হোল', 'জ্যোতির্বিদ্যা', 'মহাকাশ', 'পদার্থবিজ্ঞান'],
    author: 'লেখক নাম',
    readTime: 5,
    wordCount: 450,
  );

  bool _allowComments = true;
  bool _featuredArticle = false;
  String _publishAs = 'public'; // public, unlisted, private

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadArticle();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _loadArticle() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _publishArticle() async {
    setState(() {
      _isPublishing = true;
    });

    try {
      // TODO: Implement publish logic
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('প্রবন্ধ সফলভাবে প্রকাশিত হয়েছে!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('প্রকাশে সমস্যা হয়েছে: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPublishing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রকাশের পূর্বরূপ'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'পূর্বরূপ'),
            Tab(text: 'সেটিংস'),
          ],
        ),
      ),
      body: _isLoading 
        ? _buildLoadingView()
        : TabBarView(
            controller: _tabController,
            children: [
              _buildPreviewTab(),
              _buildSettingsTab(),
            ],
          ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: BoxDecoration(
        gradient: context.cosmic.stardustGradient,
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppConstants.defaultPadding),
            Text('লোড হচ্ছে...'),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildArticleHeader(),
          const SizedBox(height: AppConstants.largePadding),
          _buildArticleContent(),
          const SizedBox(height: AppConstants.extraLargePadding),
        ],
      ),
    );
  }

  Widget _buildArticleHeader() {
    final categoryColor = context.cosmic.categoryColors[_article.category] ?? Colors.grey;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: context.cosmic.cosmicGradient.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
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
                  color: categoryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                ),
                child: Text(
                  AppConstants.categoriesInBengali[_article.category] ?? _article.category,
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${_article.readTime} মিনিট পড়ার সময়',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            _article.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            _article.summary,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _article.author[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                _article.author,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                'আজ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (_article.tags.isNotEmpty) ...[
            const SizedBox(height: AppConstants.defaultPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding / 2,
              children: _article.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallPadding,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.preview, size: 18),
              const SizedBox(width: AppConstants.smallPadding),
              Text(
                'প্রবন্ধের বিষয়বস্তু',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
            ),
            child: Text(
              _article.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVisibilitySettings(),
          const SizedBox(height: AppConstants.largePadding),
          _buildInteractionSettings(),
          const SizedBox(height: AppConstants.largePadding),
          _buildArticleStats(),
          const SizedBox(height: AppConstants.extraLargePadding),
        ],
      ),
    );
  }

  Widget _buildVisibilitySettings() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'প্রকাশনা সেটিংস',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          RadioListTile<String>(
            title: const Text('সবার জন্য দৃশ্যমান'),
            subtitle: const Text('যে কেউ এই প্রবন্ধ দেখতে পারবেন'),
            value: 'public',
            groupValue: _publishAs,
            onChanged: (value) => setState(() => _publishAs = value!),
          ),
          RadioListTile<String>(
            title: const Text('লিংক দিয়ে দেখা যাবে'),
            subtitle: const Text('শুধুমাত্র লিংক জানা থাকলে দেখা যাবে'),
            value: 'unlisted',
            groupValue: _publishAs,
            onChanged: (value) => setState(() => _publishAs = value!),
          ),
          RadioListTile<String>(
            title: const Text('ব্যক্তিগত'),
            subtitle: const Text('শুধুমাত্র আপনি দেখতে পারবেন'),
            value: 'private',
            groupValue: _publishAs,
            onChanged: (value) => setState(() => _publishAs = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionSettings() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ইন্টারঅ্যাকশন সেটিংস',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          SwitchListTile(
            title: const Text('মন্তব্য অনুমোদিত'),
            subtitle: const Text('পাঠকরা মন্তব্য করতে পারবেন'),
            value: _allowComments,
            onChanged: (value) => setState(() => _allowComments = value),
          ),
          SwitchListTile(
            title: const Text('ফিচার্ড আর্টিকেল'),
            subtitle: const Text('প্রধান পাতায় হাইলাইট করা হবে'),
            value: _featuredArticle,
            onChanged: (value) => setState(() => _featuredArticle = value),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleStats() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: context.cosmic.cosmicGradient.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'প্রবন্ধের পরিসংখ্যান',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.text_fields,
                  label: 'মোট শব্দ',
                  value: '${_article.wordCount}',
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.schedule,
                  label: 'পড়ার সময়',
                  value: '${_article.readTime} মিনিট',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_offer,
                  label: 'ট্যাগ সংখ্যা',
                  value: '${_article.tags.length}',
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.category,
                  label: 'বিভাগ',
                  value: AppConstants.categoriesInBengali[_article.category] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            OutlinedButton(
              onPressed: _isPublishing ? null : () {
                GoRouter.of(context).go(RouteNames.createArticle);
              },
              child: const Text('ফিরে যান'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _isPublishing ? null : _publishArticle,
              icon: _isPublishing 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.publish, size: 18),
              label: Text(_isPublishing ? 'প্রকাশ হচ্ছে...' : 'প্রকাশ করুন'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticlePreview {

  ArticlePreview({
    required this.title,
    required this.summary,
    required this.category,
    required this.content,
    required this.tags,
    required this.author,
    required this.readTime,
    required this.wordCount,
  });
  final String title;
  final String summary;
  final String category;
  final String content;
  final List<String> tags;
  final String author;
  final int readTime;
  final int wordCount;
}