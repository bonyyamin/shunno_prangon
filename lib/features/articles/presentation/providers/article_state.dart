// // lib/features/discover/presentation/providers/article_state.dart
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:shunno_prangon/features/discover/domain/entities/search_result.dart';

// part 'article_state.freezed.dart';

// @freezed
// class ArticleState with _$ArticleState {
//   const factory ArticleState({
//     @Default([]) List<SearchResult> articles,
//     @Default(false) bool isLoading,
//     @Default(false) bool isLoadingMore,
//     @Default(false) bool hasReachedMax,
//     @Default(null) String? error,
//     @Default(null) String? lastDocumentId,
//     @Default(10) int limit,
//   }) = _ArticleState;
// }

// @freezed
// class ArticleDetailState with _$ArticleDetailState {
//   const factory ArticleDetailState({
//     @Default(null) SearchResult? article,
//     @Default(false) bool isLoading,
//     @Default(false) bool isBookmarked,
//     @Default(false) bool isLiked,
//     @Default(0) int likeCount,
//     @Default(0) int viewCount,
//     @Default(null) String? error,
//   }) = _ArticleDetailState;
// }

// @freezed
// class ArticleFilterState with _$ArticleFilterState {
//   const factory ArticleFilterState({
//     @Default(null) String? selectedCategory,
//     @Default(null) String? selectedAuthor,
//     @Default(null) DateTimeRange? dateRange,
//     @Default(null) Duration? readTimeFilter,
//     @Default('newest') String sortBy, // 'newest', 'oldest', 'popular', 'trending'
//     @Default(null) String? searchQuery,
//   }) = _ArticleFilterState;

//   const ArticleFilterState._();

//   bool get hasActiveFilters =>
//       selectedCategory != null ||
//       selectedAuthor != null ||
//       dateRange != null ||
//       readTimeFilter != null ||
//       sortBy != 'newest' ||
//       (searchQuery != null && searchQuery!.isNotEmpty);
// }

// @freezed
// class BookmarkState with _$BookmarkState {
//   const factory BookmarkState({
//     @Default([]) List<SearchResult> bookmarkedArticles,
//     @Default(false) bool isLoading,
//     @Default(null) String? error,
//   }) = _BookmarkState;
// }

// @freezed
// class RecentSearchState with _$RecentSearchState {
//   const factory RecentSearchState({
//     @Default([]) List<String> recentSearches,
//     @Default(false) bool isLoading,
//     @Default(null) String? error,
//   }) = _RecentSearchState;
// }