import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class DeleteDraftUseCase {

  DeleteDraftUseCase(this._repository);
  final EditorRepository _repository;

  /// Delete a single draft
  Future<Result<void, RepositoryException>> call(
    DeleteDraftParams params,
  ) async {
    // Validate parameters
    if (params.draftId.trim().isEmpty) {
      return Result.error(
        const RepositoryException('Draft ID is required'),
      );
    }

    try {
      // Check if draft exists before attempting deletion
      if (params.verifyExistence) {
        final existsResult = await _repository.getDraft(params.draftId);
        if (existsResult.isError) {
          return Result.error(existsResult.asError);
        }

        if (existsResult.asSuccess == null) {
          return Result.error(
            const RepositoryException('Draft not found'),
          );
        }

        // Additional verification could be added here
        // e.g., checking if user has permission to delete this draft
      }

      // Perform the deletion
      final result = await _repository.deleteDraft(params.draftId);

      if (result.isSuccess && params.clearAutoSave) {
        // Clear any auto-saved content for this draft
        // Note: This might fail but shouldn't prevent the main deletion
        try {
          // We don't have a specific method for clearing auto-save,
          // but we can attempt to save empty auto-save content
          await _repository.autoSaveDraftContent(
            draftId: params.draftId,
            title: '',
            content: '',
            summary: '',
          );
        } catch (e) {
          // Auto-save cleanup failed, but main deletion succeeded
          // This is not critical, so we don't fail the entire operation
        }
      }

      return result;
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to delete draft: $e'),
      );
    }
  }

  /// Delete multiple drafts
  Future<Result<DeleteMultipleResult, RepositoryException>> deleteMultiple(
    List<String> draftIds, {
    bool continueOnError = true,
  }) async {
    if (draftIds.isEmpty) {
      return Result.error(
        const RepositoryException('At least one draft ID is required'),
      );
    }

    final results = DeleteMultipleResult(
      successful: [],
      failed: [],
      totalCount: draftIds.length,
    );

    for (final draftId in draftIds) {
      try {
        final deleteResult = await call(
          DeleteDraftParams(
            draftId: draftId,
            verifyExistence: false, // Skip verification for batch operations
            clearAutoSave: true,
          ),
        );

        if (deleteResult.isSuccess) {
          results.successful.add(draftId);
        } else {
          results.failed.add(
            DeleteFailure(
              draftId: draftId,
              error: deleteResult.asError.message,
            ),
          );

          if (!continueOnError) {
            break;
          }
        }
      } catch (e) {
        results.failed.add(
          DeleteFailure(
            draftId: draftId,
            error: 'Unexpected error: $e',
          ),
        );

        if (!continueOnError) {
          break;
        }
      }
    }

    // Return success if at least one deletion succeeded
    if (results.successful.isNotEmpty) {
      return Result.success(results);
    } else {
      return Result.error(
        RepositoryException(
          'Failed to delete any drafts. First error: ${results.failed.first.error}',
        ),
      );
    }
  }

  /// Delete all drafts for current user (with confirmation)
  Future<Result<DeleteMultipleResult, RepositoryException>> deleteAll({
    required bool confirmed,
    List<String> excludeIds = const [],
  }) async {
    if (!confirmed) {
      return Result.error(
        const RepositoryException('Deletion must be explicitly confirmed'),
      );
    }

    try {
      // Get all user drafts first
      final getDraftsResult = await _repository.getUserDrafts();
      
      if (getDraftsResult.isError) {
        return Result.error(getDraftsResult.asError);
      }

      final allDrafts = getDraftsResult.asSuccess;
      
      // Filter out excluded IDs
      final draftsToDelete = allDrafts
          .where((draft) => !excludeIds.contains(draft.id))
          .map((draft) => draft.id)
          .toList();

      if (draftsToDelete.isEmpty) {
        return Result.success(
          DeleteMultipleResult(
            successful: [],
            failed: [],
            totalCount: 0,
          ),
        );
      }

      return await deleteMultiple(draftsToDelete);
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to delete all drafts: $e'),
      );
    }
  }

  /// Delete old drafts (older than specified duration)
  Future<Result<DeleteMultipleResult, RepositoryException>> deleteOldDrafts({
    required Duration olderThan,
    int maxCount = 100,
  }) async {
    try {
      final getDraftsResult = await _repository.getUserDrafts();
      
      if (getDraftsResult.isError) {
        return Result.error(getDraftsResult.asError);
      }

      final allDrafts = getDraftsResult.asSuccess;
      final cutoffDate = DateTime.now().subtract(olderThan);
      
      // Find drafts older than cutoff date
      final oldDrafts = allDrafts
          .where((draft) => draft.lastModified.isBefore(cutoffDate))
          .take(maxCount)
          .map((draft) => draft.id)
          .toList();

      if (oldDrafts.isEmpty) {
        return Result.success(
          DeleteMultipleResult(
            successful: [],
            failed: [],
            totalCount: 0,
          ),
        );
      }

      return await deleteMultiple(oldDrafts);
    } catch (e) {
      return Result.error(
        RepositoryException('Failed to delete old drafts: $e'),
      );
    }
  }
}

/// Parameters for deleting a draft
class DeleteDraftParams {

  const DeleteDraftParams({
    required this.draftId,
    this.verifyExistence = true,
    this.clearAutoSave = true,
  });
  final String draftId;
  final bool verifyExistence;
  final bool clearAutoSave;
}

/// Result of multiple draft deletion operation
class DeleteMultipleResult {

  DeleteMultipleResult({
    required this.successful,
    required this.failed,
    required this.totalCount,
  });
  final List<String> successful;
  final List<DeleteFailure> failed;
  final int totalCount;

  int get successCount => successful.length;
  int get failureCount => failed.length;
  bool get hasFailures => failed.isNotEmpty;
  bool get allSucceeded => failed.isEmpty && successful.isNotEmpty;
  bool get allFailed => successful.isEmpty && failed.isNotEmpty;
  
  double get successRate => totalCount == 0 ? 0 : successCount / totalCount;
}

/// Information about a failed draft deletion
class DeleteFailure {

  const DeleteFailure({
    required this.draftId,
    required this.error,
  });
  final String draftId;
  final String error;

  @override
  String toString() => 'DeleteFailure(draftId: $draftId, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DeleteFailure &&
      other.draftId == draftId &&
      other.error == error;
  }

  @override
  int get hashCode => draftId.hashCode ^ error.hashCode;
}