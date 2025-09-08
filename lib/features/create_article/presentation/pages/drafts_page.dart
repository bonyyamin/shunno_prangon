import 'package:flutter/material.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/themes/theme_extensions.dart';

class DraftsPage extends StatefulWidget {
  const DraftsPage({super.key});

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for drafts
  final List<DraftArticle> _drafts = [
    DraftArticle(
      id: '1',
      title: 'ব্ল্যাক হোলের রহস্য: মহাকাশের সবচেয়ে রহস্যময় বস্তু',
      summary:
          'ব্ল্যাক হোল কী এবং কীভাবে এগুলো গঠিত হয়? এই প্রবন্ধে আমরা জানবো...',
      category: 'astronomy',
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      wordCount: 1250,
      tags: ['ব্ল্যাক হোল', 'জ্যোতির্বিদ্যা', 'মহাকাশ'],
    ),
    DraftArticle(
      id: '2',
      title: 'কোয়ান্টাম মেকানিক্সের মৌলিক ধারণা',
      summary: 'কোয়ান্টাম পদার্থবিজ্ঞানের বিস্ময়কর জগতে প্রবেশের জন্য...',
      category: 'quantum_mechanics',
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      wordCount: 850,
      tags: ['কোয়ান্টাম', 'পদার্থবিজ্ঞান'],
    ),
    DraftArticle(
      id: '3',
      title: 'মঙ্গল গ্রহে জীবনের সন্ধান',
      summary:
          'মঙ্গল গ্রহে জীবনের অস্তিত্ব খোঁজার অভিযান এবং সাম্প্রতিক আবিষ্কার...',
      category: 'space_exploration',
      lastModified: DateTime.now().subtract(const Duration(days: 3)),
      wordCount: 2100,
      tags: ['মঙ্গল', 'জীবন', 'অনুসন্ধান'],
    ),
  ];

  List<DraftArticle> get _filteredDrafts {
    if (_searchQuery.isEmpty) return _drafts;
    return _drafts
        .where(
          (draft) =>
              draft.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              draft.summary.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              draft.tags.any(
                (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
              ),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadDrafts();
  }

  void _loadDrafts() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _editDraft(DraftArticle draft) {
    Navigator.of(context).pushNamed('/create-article', arguments: draft.id);
  }

  void _deleteDraft(DraftArticle draft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('খসড়া মুছে ফেলুন'),
        content: Text(
          'আপনি কি নিশ্চিত যে "${draft.title}" খসড়াটি মুছে ফেলতে চান?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _drafts.remove(draft);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('খসড়া মুছে ফেলা হয়েছে')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
  }

  void _publishDraft(DraftArticle draft) {
    Navigator.of(context).pushNamed('/publish-preview', arguments: draft.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('খসড়া সমূহ'),
        actions: [
          IconButton(onPressed: _loadDrafts, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: context.cosmic.stardustGradient.withOpacity(0.1),
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingView()
                  : _filteredDrafts.isEmpty
                  ? _buildEmptyView()
                  : _buildDraftsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/create-article');
        },
        icon: const Icon(Icons.edit),
        label: const Text('নতুন প্রবন্ধ'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'খসড়া খুঁজুন...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppConstants.defaultPadding),
          Text('খসড়া লোড হচ্ছে...'),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            decoration: BoxDecoration(
              gradient: context.cosmic.cosmicGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_document,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          Text(
            _searchQuery.isNotEmpty
                ? 'কোনো খসড়া পাওয়া যায়নি'
                : 'এখনো কোনো খসড়া নেই',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            _searchQuery.isNotEmpty
                ? 'অন্য কীওয়ার্ড দিয়ে খোঁজ করুন'
                : 'আপনার প্রথম প্রবন্ধ লেখা শুরু করুন',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          if (_searchQuery.isEmpty)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/create-article');
              },
              icon: const Icon(Icons.add),
              label: const Text('প্রবন্ধ লিখুন'),
            ),
        ],
      ),
    );
  }

  Widget _buildDraftsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      itemCount: _filteredDrafts.length,
      itemBuilder: (context, index) {
        final draft = _filteredDrafts[index];
        return _buildDraftCard(draft);
      },
    );
  }

  Widget _buildDraftCard(DraftArticle draft) {
    final categoryColor =
        context.cosmic.categoryColors[draft.category] ?? Colors.grey;
    final timeAgo = _formatTimeAgo(draft.lastModified);

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        onTap: () => _editDraft(draft),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
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
                      borderRadius: BorderRadius.circular(
                        AppConstants.smallBorderRadius,
                      ),
                    ),
                    child: Text(
                      AppConstants.categoriesInBengali[draft.category] ??
                          draft.category,
                      style: TextStyle(
                        color: categoryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _editDraft(draft);
                          break;
                        case 'publish':
                          _publishDraft(draft);
                          break;
                        case 'delete':
                          _deleteDraft(draft);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('সম্পাদনা'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'publish',
                        child: Row(
                          children: [
                            Icon(Icons.publish, size: 18),
                            SizedBox(width: 8),
                            Text('প্রকাশ করুন'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'মুছে ফেলুন',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                draft.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                draft.summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              if (draft.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppConstants.smallPadding / 2,
                  runSpacing: AppConstants.smallPadding / 2,
                  children: draft.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallBorderRadius,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppConstants.smallPadding),
              ],
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(timeAgo, style: Theme.of(context).textTheme.bodySmall),
                  const Spacer(),
                  Icon(
                    Icons.text_fields,
                    size: 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${draft.wordCount} শব্দ',
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

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class DraftArticle {
  final String id;
  final String title;
  final String summary;
  final String category;
  final DateTime lastModified;
  final int wordCount;
  final List<String> tags;

  DraftArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.lastModified,
    required this.wordCount,
    required this.tags,
  });
}
