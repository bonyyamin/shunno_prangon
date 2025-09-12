import 'dart:io';

import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/domain/entities/draft.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class SaveDraftUseCase {

  SaveDraftUseCase(this._repository);
  final EditorRepository _repository;

  /// Save a draft with optional image upload
  Future<Result<String, RepositoryException>> call(
    SaveDraftParams params,
  ) async {
    try {
      // Validate the draft
      final validationResult = _validateDraft(params.draft);
      if (validationResult != null) {
        return Result.error(validationResult);
      }

      // Update draft with calculated values
      final updatedDraft = params.draft.withUpdatedTimestamp();

      // Convert domain entity to data model
      final draftModel = _draftToModel(updatedDraft);

      // Upload cover image if provided
      String? coverImageUrl;
      if (params.coverImage != null) {
        final imageResult = await _repository.uploadCoverImage(
          params.coverImage!,
          updatedDraft.id.isNotEmpty ? updatedDraft.id : 'temp_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (imageResult.isSuccess) {
          coverImageUrl = imageResult.asSuccess;
        } else if (params.requireImageUpload) {
          // If image upload is required and fails, return error
          return Result.error(
            const RepositoryException('Failed to upload cover image'),
          );
        }
        // If image upload is not required, continue without image
      }

      // Update draft with cover image URL if uploaded
      final finalDraftModel = coverImageUrl != null
          ? draftModel.copyWith(coverImageUrl: coverImageUrl)
          : draftModel;

      // Save the draft
      final result = await _repository.saveDraft(finalDraftModel);

      if (result.isSuccess) {
        // Perform auto-save if enabled
        if (params.enableAutoSave) {
          await _repository.autoSaveDraftContent(
            draftId: result.asSuccess,
            title: updatedDraft.title,
            content: updatedDraft.content,
            summary: updatedDraft.summary,
          );
        }
      }

      return result;
    } catch (e) {
      return Result.error(
        RepositoryException('Unexpected error while saving draft: $e'),
      );
    }
  }

  /// Quick save for auto-save functionality
  Future<Result<void, RepositoryException>> autoSave(
    AutoSaveParams params,
  ) async {
    return await _repository.autoSaveDraftContent(
      draftId: params.draftId,
      title: params.title,
      content: params.content,
      summary: params.summary,
    );
  }

  /// Validate draft before saving
  RepositoryException? _validateDraft(Draft draft) {
    if (draft.authorId.isEmpty) {
      return const RepositoryException('Author ID is required');
    }

    if (draft.authorName.isEmpty) {
      return const RepositoryException('Author name is required');
    }

    // At least title should be present for a draft
    if (draft.title.trim().isEmpty && draft.content.trim().isEmpty) {
      return const RepositoryException('Draft must have either title or content');
    }

    // Validate category if provided
    if (draft.category.isNotEmpty && !_isValidCategory(draft.category)) {
      return const RepositoryException('Invalid category selected');
    }

    // Validate tags
    if (draft.tags.length > 10) {
      return const RepositoryException('Maximum 10 tags are allowed');
    }

    for (final tag in draft.tags) {
      if (tag.trim().isEmpty) {
        return const RepositoryException('Empty tags are not allowed');
      }
      if (tag.length > 50) {
        return const RepositoryException('Tag length cannot exceed 50 characters');
      }
    }

    return null;
  }

  /// Check if category is valid
  bool _isValidCategory(String category) {
    const validCategories = [
      'astronomy',
      'physics',
      'mathematics',
      'chemistry',
      'biology',
      'earth_science',
      'computer_science',
      'engineering',
      'medicine',
      'space_exploration',
      'quantum_mechanics',
      'artificial_intelligence',
      'climate_change',
      'evolution',
      'genetics',
    ];
    return validCategories.contains(category);
  }

  /// Convert domain entity to data model
  DraftModel _draftToModel(Draft draft) {
    return DraftModel(
      id: draft.id,
      title: draft.title,
      summary: draft.summary,
      content: draft.content,
      category: draft.category,
      authorId: draft.authorId,
      authorName: draft.authorName,
      tags: draft.tags,
      createdAt: draft.createdAt,
      lastModified: draft.lastModified,
      wordCount: draft.wordCount,
      readTimeMinutes: draft.readTimeMinutes,
      isAutoSaved: draft.isAutoSaved,
      coverImageUrl: draft.coverImageUrl,
    );
  }
}

/// Parameters for saving a draft
class SaveDraftParams {

  const SaveDraftParams({
    required this.draft,
    this.coverImage,
    this.requireImageUpload = false,
    this.enableAutoSave = true,
  });
  final Draft draft;
  final File? coverImage;
  final bool requireImageUpload;
  final bool enableAutoSave;
}

/// Parameters for auto-save functionality
class AutoSaveParams {

  const AutoSaveParams({
    required this.draftId,
    required this.title,
    required this.content,
    required this.summary,
  });
  final String draftId;
  final String title;
  final String content;
  final String summary;
}