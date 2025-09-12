import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/domain/entities/draft.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class GetDraftsUseCase {

  GetDraftsUseCase(this._repository);
  final EditorRepository _repository;

  /// Get all user drafts with optional filtering and sorting
  Future<Result<List<Draft>, RepositoryException>> call(
    GetDraftsParams params,
  ) async {
    try {
      // Get drafts from repository
      final result = await _repository.getUserDrafts(
        forceRefresh: params.forceRefresh,
      );

      if (result.isError) {
        return Result.error(result.asError);
      }

      // Convert data models to domain entities
      List<Draft> drafts = result.asSuccess
          .map((model) => _modelToDraft(model))
          .toList();

      // Apply filtering
      if (params.filter != null) {
        drafts = _applyFilter(drafts, params.filter!);
      }

      // Apply search query
      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        drafts = _applySearch(drafts, params.searchQuery!);
      }

      // Apply sorting
      drafts = _applySorting(drafts, params.sortBy, params.sortOrder);

      // Apply pagination
      if (params.limit != null) {
        final startIndex = (params.page - 1) * params.limit!;
        final endIndex = startIndex + params.limit!;
        
        if (startIndex < drafts.length) {
          drafts = drafts.sublist(
            startIndex,
            endIndex > drafts.length ? drafts.length : endIndex,
          );
        } else {
          drafts = [];
        }
      }

      return Result.success(drafts);
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to get drafts: $e'),
      );
    }
  }

  /// Get a specific draft by ID
  Future<Result<Draft?, RepositoryException>> getDraft(String draftId) async {
    if (draftId.trim().isEmpty) {
      return Result.error(
        const RepositoryException('Draft ID is required'),
      );
    }

    try {
      final result = await _repository.getDraft(draftId);

      if (result.isError) {
        return Result.error(result.asError);
      }

      final draftModel = result.asSuccess;
      if (draftModel == null) {
        return Result.success(null);
      }

      return Result.success(_modelToDraft(draftModel));
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to get draft: $e'),
      );
    }
  }

  /// Get auto-saved content for a draft
  Future<Result<Map<String, String>?, RepositoryException>> getAutoSavedContent(
    String draftId,
  ) async {
    if (draftId.trim().isEmpty) {
      return Result.error(
        const RepositoryException('Draft ID is required'),
      );
    }

    return await _repository.getAutoSavedContent(draftId);
  }

  /// Search drafts with specific query
  Future<Result<List<Draft>, RepositoryException>> searchDrafts(
    String query, {
    SearchScope scope = SearchScope.all,
  }) async {
    if (query.trim().isEmpty) {
      return call(const GetDraftsParams());
    }

    try {
      final result = await _repository.searchDrafts(query);

      if (result.isError) {
        return Result.error(result.asError);
      }

      List<Draft> drafts = result.asSuccess
          .map((model) => _modelToDraft(model))
          .toList();

      // Apply search scope filtering
      if (scope != SearchScope.all) {
        drafts = _applySearchScope(drafts, query, scope);
      }

      return Result.success(drafts);
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to search drafts: $e'),
      );
    }
  }

  /// Apply filter to drafts list
  List<Draft> _applyFilter(List<Draft> drafts, DraftFilter filter) {
    return drafts.where((draft) {
      // Filter by category
      if (filter.categories.isNotEmpty && 
          !filter.categories.contains(draft.category)) {
        return false;
      }

      // Filter by tags
      if (filter.tags.isNotEmpty) {
        final hasMatchingTag = filter.tags.any((tag) => 
            draft.tags.contains(tag));
        if (!hasMatchingTag) return false;
      }

      // Filter by date range
      if (filter.dateFrom != null && 
          draft.lastModified.isBefore(filter.dateFrom!)) {
        return false;
      }

      if (filter.dateTo != null && 
          draft.lastModified.isAfter(filter.dateTo!)) {
        return false;
      }

      // Filter by content status
      switch (filter.contentStatus) {
        case ContentStatus.hasContent:
          return draft.hasContent;
        case ContentStatus.empty:
          return !draft.hasContent;
        case ContentStatus.readyToPublish:
          return draft.isReadyToPublish;
        case ContentStatus.all:
          return true;
      }
    }).toList();
  }

  /// Apply search query to drafts list
  List<Draft> _applySearch(List<Draft> drafts, String query) {
    final lowerQuery = query.toLowerCase();
    
    return drafts.where((draft) {
      return draft.title.toLowerCase().contains(lowerQuery) ||
          draft.summary.toLowerCase().contains(lowerQuery) ||
          draft.content.toLowerCase().contains(lowerQuery) ||
          draft.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Apply search scope filtering
  List<Draft> _applySearchScope(List<Draft> drafts, String query, SearchScope scope) {
    final lowerQuery = query.toLowerCase();
    
    return drafts.where((draft) {
      switch (scope) {
        case SearchScope.title:
          return draft.title.toLowerCase().contains(lowerQuery);
        case SearchScope.content:
          return draft.content.toLowerCase().contains(lowerQuery);
        case SearchScope.tags:
          return draft.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        case SearchScope.all:
          return true;
      }
    }).toList();
  }

  /// Apply sorting to drafts list
  List<Draft> _applySorting(List<Draft> drafts, SortBy sortBy, SortOrder sortOrder) {
    drafts.sort((a, b) {
      int comparison;
      
      switch (sortBy) {
        case SortBy.lastModified:
          comparison = a.lastModified.compareTo(b.lastModified);
          break;
        case SortBy.created:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case SortBy.title:
          comparison = a.title.compareTo(b.title);
          break;
        case SortBy.wordCount:
          comparison = a.wordCount.compareTo(b.wordCount);
          break;
        case SortBy.category:
          comparison = a.category.compareTo(b.category);
          break;
      }

      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return drafts;
  }

  /// Convert data model to domain entity
  Draft _modelToDraft(DraftModel model) {
    return Draft(
      id: model.id,
      title: model.title,
      summary: model.summary,
      content: model.content,
      category: model.category,
      authorId: model.authorId,
      authorName: model.authorName,
      tags: model.tags,
      createdAt: model.createdAt,
      lastModified: model.lastModified,
      wordCount: model.wordCount,
      readTimeMinutes: model.readTimeMinutes,
      isAutoSaved: model.isAutoSaved,
      coverImageUrl: model.coverImageUrl,
    );
  }
}

/// Parameters for getting drafts
class GetDraftsParams {

  const GetDraftsParams({
    this.forceRefresh = false,
    this.filter,
    this.searchQuery,
    this.sortBy = SortBy.lastModified,
    this.sortOrder = SortOrder.descending,
    this.limit,
    this.page = 1,
  });
  final bool forceRefresh;
  final DraftFilter? filter;
  final String? searchQuery;
  final SortBy sortBy;
  final SortOrder sortOrder;
  final int? limit;
  final int page;
}

/// Filter options for drafts
class DraftFilter {

  const DraftFilter({
    this.categories = const [],
    this.tags = const [],
    this.dateFrom,
    this.dateTo,
    this.contentStatus = ContentStatus.all,
  });
  final List<String> categories;
  final List<String> tags;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final ContentStatus contentStatus;
}

/// Sorting options
enum SortBy {
  lastModified,
  created,
  title,
  wordCount,
  category,
}

enum SortOrder {
  ascending,
  descending,
}

/// Content status filter
enum ContentStatus {
  all,
  hasContent,
  empty,
  readyToPublish,
}

/// Search scope options
enum SearchScope {
  all,
  title,
  content,
  tags,
}