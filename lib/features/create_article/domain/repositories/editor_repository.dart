import 'dart:io';
import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/data/models/publish_request_model.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

/// Domain repository interface for editor functionality
/// This interface defines the contract for article/draft management
/// and is implemented by the data layer repository
abstract class EditorRepository {
  // ==================== DRAFT OPERATIONS ====================
  
  /// Save draft with offline support
  /// Returns the draft ID on success
  Future<Result<String, RepositoryException>> saveDraft(DraftModel draft);

  /// Get draft by ID with offline support
  /// Returns null if draft not found
  Future<Result<DraftModel?, RepositoryException>> getDraft(String draftId);

  /// Get all user drafts with offline support
  /// [forceRefresh] - Force refresh from remote source
  Future<Result<List<DraftModel>, RepositoryException>> getUserDrafts({
    bool forceRefresh = false,
  });

  /// Update existing draft
  Future<Result<void, RepositoryException>> updateDraft(DraftModel draft);

  /// Delete draft from both local and remote storage
  Future<Result<void, RepositoryException>> deleteDraft(String draftId);

  /// Search drafts by query string
  /// Searches in title, summary, content, and tags
  Future<Result<List<DraftModel>, RepositoryException>> searchDrafts(String query);

  // ==================== AUTO-SAVE OPERATIONS ====================

  /// Auto-save draft content for recovery purposes
  /// This is typically called during editing to prevent data loss
  Future<Result<void, RepositoryException>> autoSaveDraftContent({
    required String draftId,
    required String title,
    required String content,
    required String summary,
  });

  /// Get auto-saved content for a draft
  /// Returns null if no auto-saved content exists
  Future<Result<Map<String, String>?, RepositoryException>> getAutoSavedContent(
    String draftId,
  );

  // ==================== PUBLISHING OPERATIONS ====================

  /// Publish article from draft or new content
  /// Returns the published article ID
  Future<Result<String, RepositoryException>> publishArticle(
    PublishRequestModel publishRequest,
  );

  /// Get published article by ID
  /// Returns null if article not found
  Future<Result<PublishedArticleModel?, RepositoryException>> getPublishedArticle(
    String articleId,
  );

  /// Get all published articles for current user
  Future<Result<List<PublishedArticleModel>, RepositoryException>> getUserPublishedArticles();

  /// Update an existing published article
  Future<Result<void, RepositoryException>> updatePublishedArticle(
    PublishedArticleModel article,
  );

  // ==================== MEDIA OPERATIONS ====================

  /// Upload cover image for article/draft
  /// Returns the image URL on success
  Future<Result<String, RepositoryException>> uploadCoverImage(
    File imageFile,
    String articleId,
  );

  /// Delete cover image by URL
  Future<Result<void, RepositoryException>> deleteCoverImage(String imageUrl);

  // ==================== ANALYTICS OPERATIONS ====================

  /// Get article analytics data
  /// Returns analytics data including views, likes, comments, etc.
  Future<Result<Map<String, dynamic>, RepositoryException>> getArticleAnalytics(
    String articleId,
  );

  /// Increment view count for an article
  Future<Result<void, RepositoryException>> incrementViewCount(String articleId);

  // ==================== SYNC & CONNECTIVITY ====================

  /// Sync local data with remote storage
  /// This handles conflict resolution and ensures data consistency
  Future<Result<void, RepositoryException>> syncData();

  /// Check if internet connection is available
  Future<bool> hasInternetConnection();

  /// Check if local data needs synchronization with remote
  Future<bool> needsSync();

  // ==================== CACHE MANAGEMENT ====================

  /// Clear all local cache data
  /// This removes all locally stored drafts and articles
  Future<Result<void, RepositoryException>> clearCache();

  /// Get storage statistics
  /// Returns information about local storage usage
  Future<Result<Map<String, dynamic>, RepositoryException>> getStorageStats();

  // ==================== STREAMING OPERATIONS ====================

  /// Stream user drafts for real-time updates
  /// This provides live updates when drafts are modified
  Stream<Result<List<DraftModel>, RepositoryException>> streamUserDrafts();

  /// Stream published articles for real-time updates
  Stream<Result<List<PublishedArticleModel>, RepositoryException>> streamUserPublishedArticles();

  // ==================== BATCH OPERATIONS ====================

  /// Save multiple drafts in a single operation
  /// Returns a map of draft IDs to their save results
  Future<Result<Map<String, Result<String, RepositoryException>>, RepositoryException>> 
      saveDrafts(List<DraftModel> drafts);

  /// Delete multiple drafts in a single operation
  /// Returns a map of draft IDs to their deletion results
  Future<Result<Map<String, Result<void, RepositoryException>>, RepositoryException>> 
      deleteDrafts(List<String> draftIds);

  // ==================== ADVANCED SEARCH ====================

  /// Advanced search with filters
  Future<Result<List<DraftModel>, RepositoryException>> searchDraftsAdvanced({
    String? query,
    List<String>? categories,
    List<String>? tags,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? minWordCount,
    int? maxWordCount,
  });

  /// Search published articles
  Future<Result<List<PublishedArticleModel>, RepositoryException>> searchArticles({
    String? query,
    List<String>? categories,
    List<String>? tags,
    DateTime? dateFrom,
    DateTime? dateTo,
    PublishVisibility? visibility,
  });

  // ==================== BACKUP & RESTORE ====================

  /// Export user data for backup purposes
  Future<Result<Map<String, dynamic>, RepositoryException>> exportUserData();

  /// Import user data from backup
  Future<Result<void, RepositoryException>> importUserData(
    Map<String, dynamic> data, {
    bool overwrite = false,
  });

  // ==================== COLLABORATION (Future Extension) ====================

  /// Share draft with other users (read-only)
  Future<Result<String, RepositoryException>> shareDraft(
    String draftId, {
    List<String>? userIds,
    Duration? expiry,
  });

  /// Get shared drafts accessible to current user
  Future<Result<List<DraftModel>, RepositoryException>> getSharedDrafts();

  // ==================== TEMPLATES (Future Extension) ====================

  /// Save draft as template
  Future<Result<String, RepositoryException>> saveDraftAsTemplate(
    String draftId,
    String templateName,
  );

  /// Get user's templates
  Future<Result<List<DraftModel>, RepositoryException>> getUserTemplates();

  /// Create draft from template
  Future<Result<String, RepositoryException>> createDraftFromTemplate(
    String templateId,
  );
}