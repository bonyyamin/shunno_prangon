import 'package:flutter/material.dart';
import 'package:shunno_prangon/features/create_article/presentation/pages/drafts_page.dart';
import 'package:shunno_prangon/features/create_article/presentation/pages/publish_preview_page.dart';
import 'package:shunno_prangon/features/create_article/presentation/widgets/editor_widget.dart';
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
                  MaterialPageRoute(builder: (context) => const DraftsPage()),
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
          builder: (context) =>
              PublishPreviewPage(articleId: widget.articleId ?? 'new'),
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
      body: _isLoading
          ? _buildLoadingView()
          : EditorWidget(
              formKey: _formKey,
              titleController: _titleController,
              summaryController: _summaryController,
              contentController: _contentController,
              tagController: _tagController,
              selectedCategory: _selectedCategory,
              tags: _tags,
              onCategoryChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
              onAddTag: _addTag,
              onRemoveTag: _removeTag,
            ),
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
