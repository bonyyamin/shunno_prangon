import 'dart:io';
import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/data/models/publish_request_model.dart';

abstract class EditorRepository {
  /// Save draft with offline support
  Future<Result<String, RepositoryException>> saveDraft(DraftModel draft);

  /// Get draft by ID
  Future<Result<DraftModel?, RepositoryException>> getDraft(String draftId);

  /// Get all user drafts with offline support
  Future<Result<List<DraftModel>, RepositoryException>> getUserDrafts({bool forceRefresh = false});

  /// Update draft
  Future<Result<void, RepositoryException>> updateDraft(DraftModel draft);

  /// Delete draft
  Future<Result<void, RepositoryException>> deleteDraft(String draftId);

  /// Auto-save draft content for recovery
  Future<Result<void, RepositoryException>> autoSaveDraftContent({
    required String draftId,
    required String title,
    required String content,
    required String summary,
  });

  /// Get auto-saved content
  Future<Result<Map<String, String>?, RepositoryException>> getAutoSavedContent(String draftId);

  /// Publish article
  Future<Result<String, RepositoryException>> publishArticle(PublishRequestModel publishRequest);

  /// Get published article
  Future<Result<PublishedArticleModel?, RepositoryException>> getPublishedArticle(String articleId);

  /// Get user's published articles
  Future<Result<List<PublishedArticleModel>, RepositoryException>> getUserPublishedArticles();

  /// Upload cover image
  Future<Result<String, RepositoryException>> uploadCoverImage(File imageFile, String articleId);

  /// Search drafts
  Future<Result<List<DraftModel>, RepositoryException>> searchDrafts(String query);

  /// Get article analytics
  Future<Result<Map<String, dynamic>, RepositoryException>> getArticleAnalytics(String articleId);

  /// Sync local data with remote
  Future<Result<void, RepositoryException>> syncData();

  /// Check connectivity status
  Future<bool> hasInternetConnection();

  /// Clear local cache
  Future<Result<void, RepositoryException>> clearCache();
}