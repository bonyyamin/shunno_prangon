// // lib/features/discover/presentation/providers/article_list_provider.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shunno_prangon/features/articles/presentation/providers/article_state.dart';
// import 'package:shunno_prangon/features/discover/domain/entities/search_result.dart';

// // Firebase Firestore instance provider
// final firestoreProvider = Provider<FirebaseFirestore>((ref) {
//   return FirebaseFirestore.instance;
// });

// // Article filter provider
// final articleFilterProvider = StateNotifierProvider<ArticleFilterNotifier, ArticleFilterState>((ref) {
//   return ArticleFilterNotifier();
// });

// class ArticleFilterNotifier extends StateNotifier<ArticleFilterState> {
//   ArticleFilterNotifier() : super(const ArticleFilterState());

//   void setCategory(String? category) {
//     state = state.copyWith(selectedCategory: category);
//   }

//   void setAuthor(String? author) {
//     state = state.copyWith(selectedAuthor: author);
//   }

//   void setDateRange(DateTimeRange? dateRange) {
//     state = state.copyWith(dateRange: dateRange);
//   }

//   void setReadTimeFilter(Duration? readTime) {
//     state = state.copyWith(readTimeFilter: readTime);
//   }

//   void setSortBy(String sortBy) {
//     state = state.copyWith(sortBy: sortBy);
//   }

//   void setSearchQuery(String? query) {
//     state = state.copyWith(searchQuery: query);
//   }

//   void clearFilters() {
//     state = const ArticleFilterState();
//   }

//   void clearSearchQuery() {
//     state = state.copyWith(searchQuery: null);
//   }
// }

// // Main article list provider
// final articleListProvider = StateNotifierProvider<ArticleListNotifier, ArticleState>((ref) {
//   final firestore = ref.watch(firestoreProvider);
//   return ArticleListNotifier(firestore, ref);
// });

// class ArticleListNotifier extends StateNotifier<ArticleState> {
//   final FirebaseFirestore _firestore;
//   final Ref _ref;

//   ArticleListNotifier(this._firestore, this._ref) : super(const ArticleState());

//   // Load articles with current filters
//   Future<void> loadArticles({bool refresh = false}) async {
//     if (state.isLoading && !refresh) return;

//     try {
//       state = state.copyWith(
//         isLoading: refresh ? false : true,
//         error: null,
//       );

//       final filters = _ref.read(articleFilterProvider);
//       Query query = _firestore.collection('articles');

//       // Apply filters
//       query = _applyFilters(query, filters);

//       // Apply sorting
//       query = _applySorting(query, filters.sortBy);

//       // Apply pagination
//       if (!refresh && state.lastDocumentId != null) {
//         final lastDoc = await _firestore.collection('articles').doc(state.lastDocumentId).get();
//         if (lastDoc.exists) {
//           query = query.startAfterDocument(lastDoc);
//         }
//       }

//       query = query.limit(state.limit);

//       final querySnapshot = await query.get();
//       final articles = querySnapshot.docs.map((doc) => _documentToSearchResult(doc)).toList();

//       if (refresh) {
//         state = state.copyWith(
//           articles: articles,
//           isLoading: false,
//           hasReachedMax: articles.length < state.limit,
//           lastDocumentId: articles.isNotEmpty ? articles.last.id : null,
//         );
//       } else {
//         state = state.copyWith(
//           articles: [...state.articles, ...articles],
//           isLoading: false,
//           hasReachedMax: articles.length < state.limit,
//           lastDocumentId: articles.isNotEmpty ? articles.last.id : null,
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Load more articles (pagination)
//   Future<void> loadMoreArticles() async {
//     if (state.isLoadingMore || state.hasReachedMax) return;

//     try {
//       state = state.copyWith(isLoadingMore: true, error: null);

//       final filters = _ref.read(articleFilterProvider);
//       Query query = _firestore.collection('articles');

//       // Apply filters
//       query = _applyFilters(query, filters);

//       // Apply sorting
//       query = _applySorting(query, filters.sortBy);

//       // Apply pagination
//       if (state.lastDocumentId != null) {
//         final lastDoc = await _firestore.collection('articles').doc(state.lastDocumentId).get();
//         if (lastDoc.exists) {
//           query = query.startAfterDocument(lastDoc);
//         }
//       }

//       query = query.limit(state.limit);

//       final querySnapshot = await query.get();
//       final newArticles = querySnapshot.docs.map((doc) => _documentToSearchResult(doc)).toList();

//       state = state.copyWith(
//         articles: [...state.articles, ...newArticles],
//         isLoadingMore: false,
//         hasReachedMax: newArticles.length < state.limit,
//         lastDocumentId: newArticles.isNotEmpty ? newArticles.last.id : null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoadingMore: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Search articles
//   Future<void> searchArticles(String query) async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       // Update the filter with search query
//       _ref.read(articleFilterProvider.notifier).setSearchQuery(query);

//       Query firestoreQuery = _firestore.collection('articles');

//       if (query.isNotEmpty) {
//         // For full-text search, we would typically use Algolia or similar
//         // For now, we'll search in title and description using array-contains-any
//         // This requires the title and description to be tokenized in Firestore
//         final searchTerms = query.toLowerCase().split(' ').take(10).toList();
//         firestoreQuery = firestoreQuery.where('searchTerms', arrayContainsAny: searchTerms);
//       }

//       firestoreQuery = firestoreQuery.orderBy('publishedAt', descending: true);
//       firestoreQuery = firestoreQuery.limit(state.limit);

//       final querySnapshot = await firestoreQuery.get();
//       final articles = querySnapshot.docs.map((doc) => _documentToSearchResult(doc)).toList();

//       state = state.copyWith(
//         articles: articles,
//         isLoading: false,
//         hasReachedMax: articles.length < state.limit,
//         lastDocumentId: articles.isNotEmpty ? articles.last.id : null,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Apply filters to Firestore query
//   Query _applyFilters(Query query, ArticleFilterState filters) {
//     if (filters.selectedCategory != null) {
//       query = query.where('category', isEqualTo: filters.selectedCategory);
//     }

//     if (filters.selectedAuthor != null) {
//       query = query.where('authorId', isEqualTo: filters.selectedAuthor);
//     }

//     if (filters.dateRange != null) {
//       query = query.where('publishedAt', 
//         isGreaterThanOrEqualTo: filters.dateRange!.start,
//         isLessThanOrEqualTo: filters.dateRange!.end,
//       );
//     }

//     if (filters.readTimeFilter != null) {
//       final maxReadTime = filters.readTimeFilter!.inMinutes;
//       query = query.where('readTimeMinutes', isLessThanOrEqualTo: maxReadTime);
//     }

//     return query;
//   }

//   // Apply sorting to Firestore query
//   Query _applySorting(Query query, String sortBy) {
//     switch (sortBy) {
//       case 'newest':
//         return query.orderBy('publishedAt', descending: true);
//       case 'oldest':
//         return query.orderBy('publishedAt', descending: false);
//       case 'popular':
//         return query.orderBy('viewCount', descending: true);
//       case 'trending':
//         // For trending, we might use a combination of recent views and likes
//         return query.orderBy('trendingScore', descending: true);
//       default:
//         return query.orderBy('publishedAt', descending: true);
//     }
//   }

//   // Convert Firestore document to SearchResult entity
//   SearchResult _documentToSearchResult(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
    
//     return SearchResult(
//       id: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       author: data['author'] ?? '',
//       authorId: data['authorId'] ?? '',
//       category: data['category'] ?? '',
//       publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       readTimeMinutes: data['readTimeMinutes'] ?? 5,
//       viewCount: data['viewCount'] ?? 0,
//       likeCount: data['likeCount'] ?? 0,
//       commentCount: data['commentCount'] ?? 0,
//       imageUrl: data['imageUrl'],
//       tags: List<String>.from(data['tags'] ?? []),
//       isPremium: data['isPremium'] ?? false,
//       isBookmarked: data['isBookmarked'] ?? false, // This would be user-specific
//     );
//   }

//   // Clear all articles
//   void clearArticles() {
//     state = const ArticleState();
//   }

//   // Refresh articles
//   Future<void> refresh() async {
//     await loadArticles(refresh: true);
//   }
// }

// // Category-specific article provider
// final categoryArticlesProvider = StateNotifierProvider.family<CategoryArticlesNotifier, ArticleState, String>((ref, category) {
//   final firestore = ref.watch(firestoreProvider);
//   return CategoryArticlesNotifier(firestore, category);
// });

// class CategoryArticlesNotifier extends StateNotifier<ArticleState> {
//   final FirebaseFirestore _firestore;
//   final String _category;

//   CategoryArticlesNotifier(this._firestore, this._category) : super(const ArticleState());

//   Future<void> loadCategoryArticles({bool refresh = false}) async {
//     if (state.isLoading && !refresh) return;

//     try {
//       state = state.copyWith(
//         isLoading: refresh ? false : true,
//         error: null,
//       );

//       Query query = _firestore.collection('articles')
//           .where('category', isEqualTo: _category)
//           .orderBy('publishedAt', descending: true);

//       if (!refresh && state.lastDocumentId != null) {
//         final lastDoc = await _firestore.collection('articles').doc(state.lastDocumentId).get();
//         if (lastDoc.exists) {
//           query = query.startAfterDocument(lastDoc);
//         }
//       }

//       query = query.limit(state.limit);

//       final querySnapshot = await query.get();
//       final articles = querySnapshot.docs.map((doc) => _documentToSearchResult(doc)).toList();

//       if (refresh) {
//         state = state.copyWith(
//           articles: articles,
//           isLoading: false,
//           hasReachedMax: articles.length < state.limit,
//           lastDocumentId: articles.isNotEmpty ? articles.last.id : null,
//         );
//       } else {
//         state = state.copyWith(
//           articles: [...state.articles, ...articles],
//           isLoading: false,
//           hasReachedMax: articles.length < state.limit,
//           lastDocumentId: articles.isNotEmpty ? articles.last.id : null,
//         );
//       }
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> loadMoreArticles() async {
//     if (state.isLoadingMore || state.hasReachedMax) return;
//     await loadCategoryArticles(refresh: false);
//   }

//   SearchResult _documentToSearchResult(QueryDocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
    
//     return SearchResult(
//       id: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       author: data['author'] ?? '',
//       authorId: data['authorId'] ?? '',
//       category: data['category'] ?? '',
//       publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       readTimeMinutes: data['readTimeMinutes'] ?? 5,
//       viewCount: data['viewCount'] ?? 0,
//       likeCount: data['likeCount'] ?? 0,
//       commentCount: data['commentCount'] ?? 0,
//       imageUrl: data['imageUrl'],
//       tags: List<String>.from(data['tags'] ?? []),
//       isPremium: data['isPremium'] ?? false,
//       isBookmarked: data['isBookmarked'] ?? false,
//     );
//   }
// }

// // Trending articles provider
// final trendingArticlesProvider = FutureProvider<List<SearchResult>>((ref) async {
//   final firestore = ref.watch(firestoreProvider);
  
//   try {
//     final querySnapshot = await firestore
//         .collection('articles')
//         .orderBy('trendingScore', descending: true)
//         .limit(10)
//         .get();

//     return querySnapshot.docs.map((doc) {
//       final data = doc.data();
//       return SearchResult(
//         id: doc.id,
//         title: data['title'] ?? '',
//         description: data['description'] ?? '',
//         author: data['author'] ?? '',
//         authorId: data['authorId'] ?? '',
//         category: data['category'] ?? '',
//         publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//         readTimeMinutes: data['readTimeMinutes'] ?? 5,
//         viewCount: data['viewCount'] ?? 0,
//         likeCount: data['likeCount'] ?? 0,
//         commentCount: data['commentCount'] ?? 0,
//         imageUrl: data['imageUrl'],
//         tags: List<String>.from(data['tags'] ?? []),
//         isPremium: data['isPremium'] ?? false,
//         isBookmarked: data['isBookmarked'] ?? false,
//       );
//     }).toList();
//   } catch (e) {
//     throw Exception('Failed to load trending articles: $e');
//   }
// });

// // Recent searches provider
// final recentSearchesProvider = StateNotifierProvider<RecentSearchesNotifier, RecentSearchState>((ref) {
//   return RecentSearchesNotifier();
// });

// class RecentSearchesNotifier extends StateNotifier<RecentSearchState> {
//   RecentSearchesNotifier() : super(const RecentSearchState());

//   Future<void> addRecentSearch(String query) async {
//     if (query.trim().isEmpty) return;

//     final searches = [...state.recentSearches];
    
//     // Remove if already exists
//     searches.remove(query);
    
//     // Add to beginning
//     searches.insert(0, query);
    
//     // Keep only last 10 searches
//     if (searches.length > 10) {
//       searches.removeRange(10, searches.length);
//     }

//     state = state.copyWith(recentSearches: searches);
    
//     // In a real app, you would persist this to SharedPreferences or Firebase
//   }

//   void clearRecentSearches() {
//     state = state.copyWith(recentSearches: []);
//   }

//   void removeRecentSearch(String query) {
//     final searches = [...state.recentSearches];
//     searches.remove(query);
//     state = state.copyWith(recentSearches: searches);
//   }
// }