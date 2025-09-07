import 'package:flutter/material.dart';
import 'package:shunno_prangon/features/create_article/presentation/pages/drafts_page.dart';
import 'package:shunno_prangon/features/create_article/presentation/pages/publish_preview_page.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/themes/theme_extensions.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key, this.articleId});
  final String? articleId;

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _summaryController = TextEditingController();

  String _selectedCategory = AppConstants.categories.first;
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  bool _isDraft = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.articleId != null) {
      _loadArticle();
    }
  }

  void _loadArticle() {
    // TODO: Load existing article data
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty &&
        !_tags.contains(_tagController.text.trim())) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveDraft() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Save draft logic
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
        _isDraft = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('খসড়া সংরক্ষিত হয়েছে'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'দেখুন',
              textColor: Colors.white,
              onPressed: () {
                // Navigate to drafts page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DraftsPage(),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  void _publishArticle() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => PublishPreviewPage(articleId: widget.articleId ?? 'new'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _summaryController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.articleId != null ? 'প্রবন্ধ সম্পাদনা' : 'নতুন প্রবন্ধ',
        ),
        actions: [
          TextButton.icon(
            onPressed: _isLoading ? null : _saveDraft,
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('খসড়া'),
          ),
          const SizedBox(width: AppConstants.smallPadding),
        ],
      ),
      body: _isLoading ? _buildLoadingView() : _buildEditor(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      decoration: BoxDecoration(gradient: context.cosmic.stardustGradient),
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

  Widget _buildEditor() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleField(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildCategorySelector(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildSummaryField(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildTagsSection(),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildContentField(),
            const SizedBox(height: AppConstants.extraLargePadding),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      maxLength: AppConstants.maxTitleLength,
      decoration: const InputDecoration(
        labelText: 'প্রবন্ধের শিরোনাম',
        hintText: 'একটি আকর্ষণীয় শিরোনাম লিখুন...',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'শিরোনাম আবশ্যক';
        }
        if (value.trim().length < 10) {
          return 'শিরোনাম কমপক্ষে ১০ অক্ষরের হতে হবে';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('বিভাগ', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppConstants.smallPadding),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: AppConstants.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: context.cosmic.categoryColors[category],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        AppConstants.categoriesInBengali[category] ?? category,
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryField() {
    return TextFormField(
      controller: _summaryController,
      maxLines: 3,
      maxLength: AppConstants.maxDescriptionLength,
      decoration: const InputDecoration(
        labelText: 'সংক্ষিপ্ত বিবরণ',
        hintText:
            'প্রবন্ধের মূল বিষয়বস্তু সম্পর্কে একটি সংক্ষিপ্ত বিবরণ লিখুন...',
        prefixIcon: Icon(Icons.description_outlined),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'সংক্ষিপ্ত বিবরণ আবশ্যক';
        }
        if (value.trim().length < 20) {
          return 'সংক্ষিপ্ত বিবরণ কমপক্ষে ২০ অক্ষরের হতে হবে';
        }
        return null;
      },
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ট্যাগ সমূহ', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: 'ট্যাগ যোগ করুন',
                  hintText: 'যেমন: পদার্থবিজ্ঞান, নক্ষত্র',
                  prefixIcon: Icon(Icons.local_offer_outlined),
                ),
                onFieldSubmitted: (_) => _addTag(),
              ),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            IconButton(
              onPressed: _addTag,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        if (_tags.isNotEmpty) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Wrap(
            spacing: AppConstants.smallPadding,
            runSpacing: AppConstants.smallPadding / 2,
            children: _tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeTag(tag),
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildContentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'প্রবন্ধের মূল অংশ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // TODO: Add formatting options
                  },
                  icon: const Icon(Icons.format_bold),
                  tooltip: 'বোল্ড',
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Add formatting options
                  },
                  icon: const Icon(Icons.format_italic),
                  tooltip: 'ইটালিক',
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Add image insertion
                  },
                  icon: const Icon(Icons.image),
                  tooltip: 'ছবি যোগ করুন',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
          ),
          child: TextFormField(
            controller: _contentController,
            maxLines: 15,
            maxLength: AppConstants.maxArticleContentLength,
            decoration: const InputDecoration(
              hintText:
                  'আপনার প্রবন্ধ এখানে লিখুন...\n\nমহাকাশের রহস্য, বিজ্ঞানের নতুন আবিষ্কার, বা যে কোনো বৈজ্ঞানিক বিষয় নিয়ে আপনার চিন্তাভাবনা শেয়ার করুন।',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppConstants.defaultPadding),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'প্রবন্ধের মূল অংশ আবশ্যক';
              }
              if (value.trim().length < 100) {
                return 'প্রবন্ধ কমপক্ষে ১০০ অক্ষরের হতে হবে';
              }
              return null;
            },
          ),
        ),
      ],
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
            if (_isDraft)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.smallPadding,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.cosmic.statusColors['draft'],
                  borderRadius: BorderRadius.circular(
                    AppConstants.smallBorderRadius,
                  ),
                ),
                child: const Text(
                  'খসড়া',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _saveDraft,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('খসড়া সংরক্ষণ'),
            ),
            const SizedBox(width: AppConstants.smallPadding),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _publishArticle,
              icon: const Icon(Icons.publish, size: 18),
              label: const Text('পূর্বরূপ দেখুন'),
            ),
          ],
        ),
      ),
    );
  }
}
