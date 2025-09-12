
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/datasources/editor_local_datasource.dart';
import 'package:shunno_prangon/features/create_article/data/datasources/editor_remote_datasource.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/data/models/publish_request_model.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class EditorRepositoryImpl implements EditorRepository {

  EditorRepositoryImpl({
    required EditorLocalDatasource localDatasource,
    required EditorRemoteDatasource remoteDatasource,
    Connectivity? connectivity,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _connectivity = connectivity ?? Connectivity();
  final EditorLocalDatasource _localDatasource;
  final EditorRemoteDatasource _remoteDatasource;
  final Connectivity _connectivity;

  @override
  Future<Result<String, RepositoryException>> saveDraft(DraftModel draft) async {
    try {
      // Always save to local storage first
      await _localDatasource.saveDraft(draft);

      if (await hasInternetConnection()) {
        try {
          final remoteId = await _remoteDatasource.saveDraft(draft);

          // Update local draft with remote ID if different
          if (remoteId != draft.id) {
            final updatedDraft = draft.copyWith(id: remoteId);
            await _localDatasource.saveDraft(updatedDraft);
          }

          return Result.success(remoteId);
        } catch (e) {
          // Remote save failed, but local succeeded
          return Result.success(draft.id);
        }
      } else {
        // Offline mode
        return Result.success(draft.id);
      }
    } catch (e) {
      return Result.error(RepositoryException('Failed to save draft: $e'));
    }
  }

  @override
  Future<Result<DraftModel?, RepositoryException>> getDraft(String draftId) async {
    try {
      // Try local first
      final localDraft = await _localDatasource.getDraft(draftId);

      if (!await hasInternetConnection()) {
        return Result.success(localDraft);
      }

      try {
        // Try to get from remote for the latest version
        final remoteDraft = await _remoteDatasource.getDraft(draftId);

        if (remoteDraft != null) {
          // Cache the remote version locally
          await _localDatasource.saveDraft(remoteDraft);
          return Result.success(remoteDraft);
        }

        return Result.success(localDraft);
      } catch (e) {
        // Remote failed, return local version
        return Result.success(localDraft);
      }
    } catch (e) {
      return Result.error(RepositoryException('Failed to get draft: $e'));
    }
  }

  @override
  Future<Result<List<DraftModel>, RepositoryException>> getUserDrafts(
      {bool forceRefresh = false}) async {
    try {
      if (!await hasInternetConnection() && !forceRefresh) {
        final localDrafts = await _localDatasource.getAllDrafts();
        return Result.success(localDrafts);
      }

      try {
        final remoteDrafts = await _remoteDatasource.getUserDrafts();

        // Update local cache with remote data
        for (final draft in remoteDrafts) {
          await _localDatasource.saveDraft(draft);
        }

        return Result.success(remoteDrafts);
      } catch (e) {
        // Fallback to local data if remote fails
        final localDrafts = await _localDatasource.getAllDrafts();
        return Result.success(localDrafts);
      }
    } catch (e) {
      return Result.error(RepositoryException('Failed to get user drafts: $e'));
    }
  }

  @override
  Future<Result<void, RepositoryException>> updateDraft(DraftModel draft) async {
    try {
      final updatedDraft = draft.withUpdatedTimestamp();

      // Always update local first
      await _localDatasource.saveDraft(updatedDraft);

      if (await hasInternetConnection()) {
        try {
          await _remoteDatasource.updateDraft(updatedDraft);
        } catch (e) {
          // Remote update failed, but local succeeded
          // This will be synced later
        }
      }

      return Result.success(null);
    } catch (e) {
      return Result.error(RepositoryException('Failed to update draft: $e'));
    }
  }

  @override
  Future<Result<void, RepositoryException>> deleteDraft(String draftId) async {
    try {
      // Delete from local storage
      await _localDatasource.deleteDraft(draftId);

      if (await hasInternetConnection()) {
        try {
          await _remoteDatasource.deleteDraft(draftId);
        } catch (e) {
          // Remote delete failed, but local succeeded
          // Note: This could lead to inconsistency, consider a sync strategy
        }
      }

      return Result.success(null);
    } catch (e) {
      return Result.error(RepositoryException('Failed to delete draft: $e'));
    }
  }

  @override
  Future<Result<void, RepositoryException>> autoSaveDraftContent({
    required String draftId,
    required String title,
    required String content,
    required String summary,
  }) async {
    try {
      await _localDatasource.autoSaveDraftContent(
        draftId: draftId,
        title: title,
        content: content,
        summary: summary,
      );
      return Result.success(null);
    } catch (e) {
      return Result.error(RepositoryException('Failed to auto-save: $e'));
    }
  }

  @override
  Future<Result<Map<String, String>?, RepositoryException>> getAutoSavedContent(
      String draftId) async {
    try {
      final content = await _localDatasource.getAutoSavedContent(draftId);
      return Result.success(content);
    } catch (e) {
      return Result.error(
          RepositoryException('Failed to get auto-saved content: $e'));
    }
  }

  @override
  Future<Result<String, RepositoryException>> publishArticle(
      PublishRequestModel publishRequest) async {
    try {
      if (!await hasInternetConnection()) {
        return Result.error(
            const RepositoryException('Internet connection required to publish'));
      }

      final articleId = await _remoteDatasource.publishArticle(publishRequest);

      // Cache the published article locally
      final publishedArticle = await _remoteDatasource.getPublishedArticle(articleId);
      if (publishedArticle != null) {
        await _localDatasource.cachePublishedArticle(publishedArticle);
      }

      return Result.success(articleId);
    } catch (e) {
      return Result.error(RepositoryException('Failed to publish article: $e'));
    }
  }

  @override
  Future<Result<PublishedArticleModel?, RepositoryException>> getPublishedArticle(
      String articleId) async {
    try {
      // Try cache first
      final cachedArticle = await _localDatasource.getCachedArticle(articleId);

      if (!await hasInternetConnection()) {
        return Result.success(cachedArticle);
      }

      try {
        // Get latest from remote
        final remoteArticle = await _remoteDatasource.getPublishedArticle(articleId);

        if (remoteArticle != null) {
          // Update cache
          await _localDatasource.cachePublishedArticle(remoteArticle);
          return Result.success(remoteArticle);
        }

        return Result.success(cachedArticle);
      } catch (e) {
        // Return cached version if remote fails
        return Result.success(cachedArticle);
      }
    } catch (e) {
      return Result.error(
          RepositoryException('Failed to get published article: $e'));
    }
  }

  @override
  Future<Result<List<PublishedArticleModel>, RepositoryException>>
      getUserPublishedArticles() async {
    try {
      if (!await hasInternetConnection()) {
        final cachedArticles = await _localDatasource.getAllCachedArticles();
        return Result.success(cachedArticles);
      }

      try {
        final remoteArticles = await _remoteDatasource.getUserPublishedArticles();

        // Update cache
        for (final article in remoteArticles) {
          await _localDatasource.cachePublishedArticle(article);
        }

        return Result.success(remoteArticles);
      } catch (e) {
        // Fallback to cached data
        final cachedArticles = await _localDatasource.getAllCachedArticles();
        return Result.success(cachedArticles);
      }
    } catch (e) {
      return Result.error(RepositoryException('Failed to get user articles: $e'));
    }
  }

  @override
  Future<Result<String, RepositoryException>> uploadCoverImage(
      File imageFile, String articleId) async {
    try {
      if (!await hasInternetConnection()) {
        return Result.error(const RepositoryException(
            'Internet connection required to upload image'));
      }

      final imageUrl = await _remoteDatasource.uploadCoverImage(imageFile, articleId);
      return Result.success(imageUrl);
    } catch (e) {
      return Result.error(RepositoryException('Failed to upload image: $e'));
    }
  }

  @override
  Future<Result<List<DraftModel>, RepositoryException>> searchDrafts(
      String query) async {
    try {
      if (!await hasInternetConnection()) {
        // Search locally when offline
        final allDrafts = await _localDatasource.getAllDrafts();
        final filteredDrafts = allDrafts.where((draft) {
          final lowerQuery = query.toLowerCase();
          return draft.title.toLowerCase().contains(lowerQuery) ||
              draft.summary.toLowerCase().contains(lowerQuery) ||
              draft.content.toLowerCase().contains(lowerQuery) ||
              draft.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        }).toList();

        return Result.success(filteredDrafts);
      }

      try {
        final results = await _remoteDatasource.searchDrafts(query);
        return Result.success(results);
      } catch (e) {
        // Fallback to local search
        final allDrafts = await _localDatasource.getAllDrafts();
        final filteredDrafts = allDrafts.where((draft) {
          final lowerQuery = query.toLowerCase();
          return draft.title.toLowerCase().contains(lowerQuery) ||
              draft.summary.toLowerCase().contains(lowerQuery) ||
              draft.content.toLowerCase().contains(lowerQuery) ||
              draft.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
        }).toList();

        return Result.success(filteredDrafts);
      }
    } catch (e) {
      return Result.error(RepositoryException('Failed to search drafts: $e'));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, RepositoryException>> getArticleAnalytics(
      String articleId) async {
    try {
      if (!await hasInternetConnection()) {
        return Result.error(const RepositoryException(
            'Internet connection required for analytics'));
      }

      final analytics = await _remoteDatasource.getArticleAnalytics(articleId);
      return Result.success(analytics);
    } catch (e) {
      return Result.error(RepositoryException('Failed to get analytics: $e'));
    }
  }

  @override
  Future<Result<void, RepositoryException>> syncData() async {
    try {
      if (!await hasInternetConnection()) {
        return Result.error(
            const RepositoryException('Internet connection required for sync'));
      }

      // Sync drafts
      final localDrafts = await _localDatasource.getAllDrafts();
      final remoteDrafts = await _remoteDatasource.getUserDrafts();

      // Upload local drafts that don't exist remotely
      for (final localDraft in localDrafts) {
        final remoteExists = remoteDrafts.any((rd) => rd.id == localDraft.id);
        if (!remoteExists) {
          try {
            await _remoteDatasource.saveDraft(localDraft);
          } catch (e) {
            // Continue with other drafts if one fails
            continue;
          }
        }
      }

      // Download remote drafts that don't exist locally
      for (final remoteDraft in remoteDrafts) {
        final localExists = localDrafts.any((ld) => ld.id == remoteDraft.id);
        if (!localExists) {
          await _localDatasource.saveDraft(remoteDraft);
        } else {
          // Update if remote is newer
          final localDraft =
              localDrafts.firstWhere((ld) => ld.id == remoteDraft.id);
          if (remoteDraft.lastModified.isAfter(localDraft.lastModified)) {
            await _localDatasource.saveDraft(remoteDraft);
          }
        }
      }

      return Result.success(null);
    } catch (e) {
      return Result.error(RepositoryException('Failed to sync data: $e'));
    }
  }

  @override
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi);
    } catch (e) {
      // Assume no connection if check fails
      return false;
    }
  }

  @override
  Future<Result<void, RepositoryException>> clearCache() async {
    try {
      await _localDatasource.clearCache();
      return Result.success(null);
    } catch (e) {
      return Result.error(RepositoryException('Failed to clear cache: $e'));
    }
  }

  // Additional utility methods

  /// Get storage statistics
  Future<Result<Map<String, int>, RepositoryException>> getStorageStats() async {
    try {
      final stats = await _localDatasource.getStorageStats();
      return Result.success(stats);
    } catch (e) {
      return Result.error(RepositoryException('Failed to get storage stats: $e'));
    }
  }

  /// Check if sync is needed
  Future<bool> needsSync() async {
    try {
      return await _localDatasource.needsSync();
    } catch (e) {
      return true; // Assume sync needed if check fails
    }
  }

  /// Stream user drafts for real-time updates (when online)
  Stream<Result<List<DraftModel>, RepositoryException>> streamUserDrafts() async* {
    if (await hasInternetConnection()) {
      try {
        yield* _remoteDatasource.streamUserDrafts().map((event) => Result.success(event));
      } catch (e) {
        yield Result.error(RepositoryException('Failed to stream drafts: $e'));
      }
    } else {
      yield Result.error(const RepositoryException('Internet connection required to stream drafts'));
    }
  }

  @override
  Future<Result<void, RepositoryException>> deleteCoverImage(String imageUrl) {
    // TODO: implement deleteCoverImage
    throw UnimplementedError();
  }

  @override
  Future<Result<void, RepositoryException>> incrementViewCount(String articleId) {
    // TODO: implement incrementViewCount
    throw UnimplementedError();
  }

  @override
  Future<Result<void, RepositoryException>> updatePublishedArticle(PublishedArticleModel article) {
    // TODO: implement updatePublishedArticle
    throw UnimplementedError();
  }

  @override
  Stream<Result<List<PublishedArticleModel>, RepositoryException>> streamUserPublishedArticles() {
    // TODO: implement streamUserPublishedArticles
    throw UnimplementedError();
  }

  @override
  Future<Result<Map<String, Result<String, RepositoryException>>, RepositoryException>> saveDrafts(List<DraftModel> drafts) {
    // TODO: implement saveDrafts
    throw UnimplementedError();
  }

  @override
  Future<Result<Map<String, Result<void, RepositoryException>>, RepositoryException>> deleteDrafts(List<String> draftIds) {
    // TODO: implement deleteDrafts
    throw UnimplementedError();
  }

  @override
  Future<Result<List<DraftModel>, RepositoryException>> searchDraftsAdvanced({String? query, List<String>? categories, List<String>? tags, DateTime? dateFrom, DateTime? dateTo, int? minWordCount, int? maxWordCount}) {
    // TODO: implement searchDraftsAdvanced
    throw UnimplementedError();
  }

  @override
  Future<Result<List<PublishedArticleModel>, RepositoryException>> searchArticles({String? query, List<String>? categories, List<String>? tags, DateTime? dateFrom, DateTime? dateTo, PublishVisibility? visibility}) {
    // TODO: implement searchArticles
    throw UnimplementedError();
  }

  @override
  Future<Result<Map<String, dynamic>, RepositoryException>> exportUserData() {
    // TODO: implement exportUserData
    throw UnimplementedError();
  }

  @override
  Future<Result<void, RepositoryException>> importUserData(Map<String, dynamic> data, {bool overwrite = false}) {
    // TODO: implement importUserData
    throw UnimplementedError();
  }

  @override
  Future<Result<String, RepositoryException>> shareDraft(String draftId, {List<String>? userIds, Duration? expiry}) {
    // TODO: implement shareDraft
    throw UnimplementedError();
  }

  @override
  Future<Result<List<DraftModel>, RepositoryException>> getSharedDrafts() {
    // TODO: implement getSharedDrafts
    throw UnimplementedError();
  }

  @override
  Future<Result<String, RepositoryException>> saveDraftAsTemplate(String draftId, String templateName) {
    // TODO: implement saveDraftAsTemplate
    throw UnimplementedError();
  }

  @override
  Future<Result<List<DraftModel>, RepositoryException>> getUserTemplates() {
    // TODO: implement getUserTemplates
    throw UnimplementedError();
  }

  @override
  Future<Result<String, RepositoryException>> createDraftFromTemplate(String templateId) {
    // TODO: implement createDraftFromTemplate
    throw UnimplementedError();
  }
}
