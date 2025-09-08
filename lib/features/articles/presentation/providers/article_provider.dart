// // lib/features/discover/presentation/providers/article_provider.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shunno_prangon/features/articles/presentation/providers/article_list_provider.dart';
// import 'package:shunno_prangon/features/articles/presentation/providers/article_state.dart';
// import 'package:shunno_prangon/features/discover/domain/entities/search_result.dart';

// // Firebase Auth instance provider
// final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
//   return FirebaseAuth.instance;
// });

// // Current user provider
// final currentUserProvider = StreamProvider<User?>((ref) {
//   final auth = ref.watch(firebaseAuthProvider);
//   return auth.authStateChanges();
// });

// // Single article detail provider
// final articleDetailProvider = StateNotifierProvider.family<ArticleDetailNotifier, ArticleDetailState, String>((ref, articleId) {
//   final firestore = ref.watch(firestoreProvider);
//   final auth = ref.watch(firebaseAuthProvider);
//   return ArticleDetailNotifier(firestore, auth, articleId);
// });

// class ArticleDetailNotifier extends StateNotifier<ArticleDetailState> {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;
//   final String _articleId;

//   ArticleDetailNotifier(this._firestore, this._auth, this._articleId) : super(const ArticleDetailState()) {
//     loadArticle();
//     _listenToUserInteractions();
//   }

//   // Load article details
//   Future<void> loadArticle() async {
//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       final doc = await _firestore.collection('articles').doc(_articleId).get();
      
//       if (!doc.exists) {
//         state = state.copyWith(
//           isLoading: false,
//           error: 'Article not found',
//         );
//         return;
//       }

//       final article = _documentToSearchResult(doc);
//       final userInteractions = await _getUserInteractions();

//       state = state.copyWith(
//         article: article,
//         isLoading: false,
//         isBookmarked: userInteractions['isBookmarked'] ?? false,
//         isLiked: userInteractions['isLiked'] ?? false,
//         likeCount: article.likeCount,
//         viewCount: article.viewCount,
//       );

//       // Increment view count
//       await _incrementViewCount();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   // Get user interactions (bookmarks, likes)
//   Future<Map<String, bool>> _getUserInteractions() async {
//     final user = _auth.currentUser;
//     if (user == null) return {};

//     try {
//       final userDoc = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('interactions')
//           .doc(_articleId)
//           .get();

//       if (userDoc.exists) {
//         final data = userDoc.data()!;
//         return {
//           'isBookmarked': data['isBookmarked'] ?? false,
//           'isLiked': data['isLiked'] ?? false,
//         };
//       }
//     } catch (e) {
//       // Handle error silently for user interactions
//     }

//     return {};
//   }

//   // Listen to real-time updates for user interactions
//   void _listenToUserInteractions() {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     _firestore
//         .collection('users')
//         .doc(user.uid)
//         .collection('interactions')
//         .doc(_articleId)
//         .snapshots()
//         .listen((doc) {
//       if (doc.exists) {
//         final data = doc.data()!;
//         state = state.copyWith(
//           isBookmarked: data['isBookmarked'] ?? false,
//           isLiked: data['isLiked'] ?? false,
//         );
//       }
//     });

//     // Listen to article updates for like count
//     _firestore.collection('articles').doc(_articleId).snapshots().listen((doc) {
//       if (doc.exists) {
//         final data = doc.data()!;
//         state = state.copyWith(
//           likeCount: data['likeCount'] ?? 0,
//           viewCount: data['viewCount'] ?? 0,
//         );
//       }
//     });
//   }

//   // Toggle bookmark
//   Future<void> toggleBookmark() async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     try {
//       final userInteractionRef = _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('interactions')
//           .doc(_articleId);

//       final articleRef = _firestore.collection('articles').doc(_articleId);

//       await _firestore.runTransaction((transaction) async {
//         final userDoc = await transaction.get(userInteractionRef);
//         final articleDoc = await transaction.get(articleRef);

//         final currentlyBookmarked = userDoc.exists ? (userDoc.data()?['isBookmarked'] ?? false) : false;
//         final newBookmarkStatus = !currentlyBookmarked;

//         // Update user interactions
//         transaction.set(userInteractionRef, {
//           'isBookmarked': newBookmarkStatus,
//           'isLiked': userDoc.exists ? (userDoc.data()?['isLiked'] ?? false) : false,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));

//         // Update article bookmark count
//         if (articleDoc.exists) {
//           final currentCount = articleDoc.data()?['bookmarkCount'] ?? 0;
//           transaction.update(articleRef, {
//             'bookmarkCount': currentCount + (newBookmarkStatus ? 1 : -1),
//           });
//         }
//       });

//       state = state.copyWith(isBookmarked: !state.isBookmarked);
//     } catch (e) {
//       // Handle error - maybe show a snackbar
//     }
//   }

//   // Toggle like
//   Future<void> toggleLike() async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     try {
//       final userInteractionRef = _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('interactions')
//           .doc(_articleId);

//       final articleRef = _firestore.collection('articles').doc(_articleId);

//       await _firestore.runTransaction((transaction) async {
//         final userDoc = await transaction.get(userInteractionRef);
//         final articleDoc = await transaction.get(articleRef);

//         final currentlyLiked = userDoc.exists ? (userDoc.data()?['isLiked'] ?? false) : false;
//         final newLikeStatus = !currentlyLiked;

//         // Update user interactions
//         transaction.set(userInteractionRef, {
//           'isLiked': newLikeStatus,
//           'isBookmarked': userDoc.exists ? (userDoc.data()?['isBookmarked'] ?? false) : false,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));

//         // Update article like count
//         if (articleDoc.exists) {
//           final currentCount = articleDoc.data()?['likeCount'] ?? 0;
//           transaction.update(articleRef, {
//             'likeCount': currentCount + (newLikeStatus ? 1 : -1),
//             'trendingScore': FieldValue.increment(newLikeStatus ? 1 : -1),
//           });
//         }
//       });

//       state = state.copyWith(
//         isLiked: !state.isLiked,
//         likeCount: state.likeCount + (state.isLiked ? -1 : 1),
//       );
//     } catch (e) {
//       // Handle error
//     }
//   }

//   // Share article
//   Future<void> shareArticle() async {
//     try {
//       // Increment share count
//       await _firestore.collection('articles').doc(_articleId).update({
//         'shareCount': FieldValue.increment(1),
//         'trendingScore': FieldValue.increment(0.5), // Shares contribute to trending
//       });

//       // In a real app, you would use the share plugin here
//       // await Share.share('Check out this article: ${state.article?.title}\n\nhttps://yourapp.com/article/$_articleId');
//     } catch (e) {
//       // Handle error
//     }
//   }

//   // Increment view count
//   Future<void> _incrementViewCount() async {
//     try {
//       await _firestore.collection('articles').doc(_articleId).update({
//         'viewCount': FieldValue.increment(1),
//         'trendingScore': FieldValue.increment(0.1), // Views contribute slightly to trending
//       });
//     } catch (e) {
//       // Handle error silently
//     }
//   }

//   // Convert Firestore document to SearchResult entity
//   SearchResult _documentToSearchResult(DocumentSnapshot doc) {
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

//   // Refresh article
//   Future<void> refresh() async {
//     await loadArticle();
//   }
// }

// // Bookmarked articles provider
// final bookmarkedArticlesProvider = StateNotifierProvider<BookmarkedArticlesNotifier, BookmarkState>((ref) {
//   final firestore = ref.watch(firestoreProvider);
//   final auth = ref.watch(firebaseAuthProvider);
//   return BookmarkedArticlesNotifier(firestore, auth);
// });

// class BookmarkedArticlesNotifier extends StateNotifier<BookmarkState> {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   BookmarkedArticlesNotifier(this._firestore, this._auth) : super(const BookmarkState()) {
//     loadBookmarkedArticles();
//   }

//   Future<void> loadBookmarkedArticles() async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     try {
//       state = state.copyWith(isLoading: true, error: null);

//       // Get user's bookmarked article IDs
//       final userInteractions = await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('interactions')
//           .where('isBookmarked', isEqualTo: true)
//           .get();

//       final bookmarkedIds = userInteractions.docs.map((doc) => doc.id).toList();

//       if (bookmarkedIds.isEmpty) {
//         state = state.copyWith(
//           bookmarkedArticles: [],
//           isLoading: false,
//         );
//         return;
//       }

//       // Get bookmarked articles (Firestore 'in' query limit is 10)
//       final List<SearchResult> allBookmarkedArticles = [];
      
//       for (int i = 0; i < bookmarkedIds.length; i += 10) {
//         final batch = bookmarkedIds.skip(i).take(10).toList();
//         final articlesQuery = await _firestore
//             .collection('articles')
//             .where(FieldPath.documentId, whereIn: batch)
//             .get();

//         final batchArticles = articlesQuery.docs.map((doc) {
//           final data = doc.data();
//           return SearchResult(
//             id: doc.id,
//             title: data['title'] ?? '',
//             description: data['description'] ?? '',
//             author: data['author'] ?? '',
//             authorId: data['authorId'] ?? '',
//             category: data['category'] ?? '',
//             publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//             readTimeMinutes: data['readTimeMinutes'] ?? 5,
//             viewCount: data['viewCount'] ?? 0,
//             likeCount: data['likeCount'] ?? 0,
//             commentCount: data['commentCount'] ?? 0,
//             imageUrl: data['imageUrl'],
//             tags: List<String>.from(data['tags'] ?? []),
//             isPremium: data['isPremium'] ?? false,
//             isBookmarked: true, // We know these are bookmarked
//           );
//         }).toList();

//         allBookmarkedArticles.addAll(batchArticles);
//       }

//       // Sort by bookmark date (most recent first)
//       allBookmarkedArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

//       state = state.copyWith(
//         bookmarkedArticles: allBookmarkedArticles,
//         isLoading: false,
//       );
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         error: e.toString(),
//       );
//     }
//   }

//   Future<void> removeBookmark(String articleId) async {
//     final user = _auth.currentUser;
//     if (user == null) return;

//     try {
//       // Remove from user interactions
//       await _firestore
//           .collection('users')
//           .doc(user.uid)
//           .collection('interactions')
//           .doc(articleId)
//           .update({'isBookmarked': false});

//       // Update article bookmark count
//       await _firestore.collection('articles').doc(articleId).update({
//         'bookmarkCount': FieldValue.increment(-1),
//       });

//       // Remove from local state
//       final updatedArticles = state.bookmarkedArticles
//           .where((article) => article.id != articleId)
//           .toList();

//       state = state.copyWith(bookmarkedArticles: updatedArticles);
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//     }
//   }

//   Future<void> refresh() async {
//     await loadBookmarkedArticles();
//   }
// }

// // Author articles provider
// final authorArticlesProvider = StateNotifierProvider.family<AuthorArticlesNotifier, ArticleState, String>((ref, authorId) {
//   final firestore = ref.watch(firestoreProvider);
//   return AuthorArticlesNotifier(firestore, authorId);
// });

// class AuthorArticlesNotifier extends StateNotifier<ArticleState> {
//   final FirebaseFirestore _firestore;
//   final String _authorId;

//   AuthorArticlesNotifier(this._firestore, this._authorId) : super(const ArticleState());

//   Future<void> loadAuthorArticles({bool refresh = false}) async {
//     if (state.isLoading && !refresh) return;

//     try {
//       state = state.copyWith(
//         isLoading: refresh ? false : true,
//         error: null,
//       );

//       Query query = _firestore.collection('articles')
//           .where('authorId', isEqualTo: _authorId)
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
//     await loadAuthorArticles(refresh: false);
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

// // Related articles provider
// final relatedArticlesProvider = FutureProvider.family<List<SearchResult>, String>((ref, articleId) async {
//   final firestore = ref.watch(firestoreProvider);
  
//   try {
//     // Get the current article to find related articles
//     final articleDoc = await firestore.collection('articles').doc(articleId).get();
    
//     if (!articleDoc.exists) {
//       return [];
//     }

//     final articleData = articleDoc.data()!;
//     final category = articleData['category'] as String?;
//     final tags = List<String>.from(articleData['tags'] ?? []);

//     Query query = firestore.collection('articles');

//     // Find articles in the same category, excluding the current article
//     if (category != null) {
//       query = query.where('category', isEqualTo: category);
//     }

//     query = query.orderBy('publishedAt', descending: true).limit(10);

//     final querySnapshot = await query.get();
    
//     final relatedArticles = querySnapshot.docs
//         .where((doc) => doc.id != articleId) // Exclude current article
//         .take(5)
//         .map((doc) {
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

//     return relatedArticles;
//   } catch (e) {
//     throw Exception('Failed to load related articles: $e');
//   }
// });

// // Popular articles provider (last 7 days)
// final popularArticlesProvider = FutureProvider<List<SearchResult>>((ref) async {
//   final firestore = ref.watch(firestoreProvider);
  
//   try {
//     final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    
//     final querySnapshot = await firestore
//         .collection('articles')
//         .where('publishedAt', isGreaterThan: sevenDaysAgo)
//         .orderBy('publishedAt', descending: false)
//         .orderBy('viewCount', descending: true)
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
//     throw Exception('Failed to load popular articles: $e');
//   }
// });

// // Search suggestions provider
// final searchSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, query) async {
//   if (query.length < 2) return [];
  
//   final firestore = ref.watch(firestoreProvider);
  
//   try {
//     // In a production app, you might want to use Algolia or similar for better search
//     // For now, we'll search in titles and return suggestions
//     final querySnapshot = await firestore
//         .collection('articles')
//         .orderBy('title')
//         .startAt([query.toLowerCase()])
//         .endAt(['${query.toLowerCase()}\uf8ff'])
//         .limit(10)
//         .get();

//     final suggestions = querySnapshot.docs
//         .map((doc) => doc.data()['title'] as String)
//         .where((title) => title.toLowerCase().contains(query.toLowerCase()))
//         .take(5)
//         .toList();

//     return suggestions;
//   } catch (e) {
//     return [];
//   }
// });

// // Article analytics provider (for admin/author use)
// final articleAnalyticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, articleId) async {
//   final firestore = ref.watch(firestoreProvider);
  
//   try {
//     final doc = await firestore.collection('articles').doc(articleId).get();
    
//     if (!doc.exists) {
//       return {};
//     }

//     final data = doc.data()!;
    
//     return {
//       'viewCount': data['viewCount'] ?? 0,
//       'likeCount': data['likeCount'] ?? 0,
//       'bookmarkCount': data['bookmarkCount'] ?? 0,
//       'shareCount': data['shareCount'] ?? 0,
//       'commentCount': data['commentCount'] ?? 0,
//       'trendingScore': data['trendingScore'] ?? 0,
//       'publishedAt': (data['publishedAt'] as Timestamp?)?.toDate(),
//       'lastViewed': (data['lastViewed'] as Timestamp?)?.toDate(),
//     };
//   } catch (e) {
//     throw Exception('Failed to load article analytics: $e');
//   }
// });