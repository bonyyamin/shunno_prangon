// lib/features/profile/presentation/pages/saved_articles_page.dart
import 'package:flutter/material.dart';
import 'package:shunno_prangon/app/constants/app_constants.dart';

class SavedArticlesPage extends StatefulWidget {
  const SavedArticlesPage({super.key});

  @override
  State<SavedArticlesPage> createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  // Mock saved articles data
  final List<Map<String, dynamic>> _savedArticles = [
    {
      'id': '1',
      'title': 'বাংলা ভাষার ইতিহাস',
      'author': 'আহমেদ হোসেন',
      'publishedAt': '২ দিন আগে',
      'readTime': '৫ মিনিট পড়া',
      'category': 'ইতিহাস',
      'excerpt': 'বাংলা ভাষার সমৃদ্ধ ইতিহাস ও বিবর্তন সম্পর্কে জানুন',
      'imageUrl': 'https://via.placeholder.com/300x200',
    },
    {
      'id': '2',
      'title': 'ফুলের বাগান তৈরি',
      'author': 'নুসরাত জাহান',
      'publishedAt': '৫ দিন আগে',
      'readTime': '৩ মিনিট পড়া',
      'category': 'বাগান',
      'excerpt': 'ঘরের আঙিনায় সুন্দর ফুলের বাগান তৈরির সহজ কিছু টিপস',
      'imageUrl': 'https://via.placeholder.com/300x200',
    },
    {
      'id': '3',
      'title': 'রান্নার সহজ রেসিপি',
      'author': 'সুমাইয়া আক্তার',
      'publishedAt': '১ সপ্তাহ আগে',
      'readTime': '৭ মিনিট পড়া',
      'category': 'রান্না',
      'excerpt': 'মাত্র ৩০ মিনিটে সুস্বাদু রান্নার রেসিপি',
      'imageUrl': 'https://via.placeholder.com/300x200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সংরক্ষিত প্রবন্ধসমূহ'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _savedArticles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'কোন সংরক্ষিত প্রবন্ধ পাওয়া যায়নি',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'আপনি যে প্রবন্ধগুলি পছন্দ করেন সেগুলি সংরক্ষণ করুন এবং এখানে সেগুলি দেখতে পাবেন',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: _savedArticles.length,
              itemBuilder: (context, index) {
                final article = _savedArticles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to article detail
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Article image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              article['imageUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 150,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Article category
                          Text(
                            article['category'],
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          // Article title
                          Text(
                            article['title'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Article excerpt
                          Text(
                            article['excerpt'],
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Article meta
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                article['author'],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '• ${article['publishedAt']} • ${article['readTime']}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.bookmark_remove_outlined),
                                onPressed: () {
                                  setState(() {
                                    _savedArticles.removeAt(index);
                                  });
                                  // Show a snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${article['title']} সংরক্ষণ থেকে সরানো হয়েছে'),
                                      action: SnackBarAction(
                                        label: 'পূর্বাবস্থায় ফিরুন',
                                        onPressed: () {
                                          setState(() {
                                            _savedArticles.insert(index, article);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}