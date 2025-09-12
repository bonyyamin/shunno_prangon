import 'dart:io';

import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/models/publish_request_model.dart';
import 'package:shunno_prangon/features/create_article/domain/entities/draft.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class PublishArticleUseCase {
  PublishArticleUseCase(this._repository);
  final EditorRepository _repository;

  /// Publish an article from draft or new content
  Future<Result<PublishResult, RepositoryException>> call(
    PublishArticleParams params,
  ) async {
    try {
      // Check internet connectivity for publishing
      final hasConnection = await _repository.hasInternetConnection();
      if (!hasConnection) {
        return Result.error(
          const RepositoryException(
            'Internet connection required for publishing',
          ),
        );
      }

      // Validate publishing parameters
      final validationResult = _validateParams(params);
      if (validationResult != null) {
        return Result.error(validationResult);
      }

      // Upload cover image if provided
      String? coverImageUrl = params.draft?.coverImageUrl;
      if (params.coverImage != null) {
        final tempArticleId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        final imageResult = await _repository.uploadCoverImage(
          params.coverImage!,
          tempArticleId,
        );

        if (imageResult.isError) {
          return Result.error(
            RepositoryException(
              'Failed to upload cover image: ${imageResult.asError.message}',
            ),
          );
        }

        coverImageUrl = imageResult.asSuccess;
      }

      // Create publish request
      final publishRequest = _createPublishRequest(params, coverImageUrl);

      // Publish the article
      final publishResult = await _repository.publishArticle(publishRequest);

      if (publishResult.isError) {
        // If image was uploaded but publishing failed, we might want to clean it up
        // For now, we'll leave it as orphaned image cleanup can be handled separately
        return Result.error(publishResult.asError);
      }

      final articleId = publishResult.asSuccess;

      // Get the published article for result
      final getArticleResult = await _repository.getPublishedArticle(articleId);

      final publishedArticle = getArticleResult.isSuccess
          ? getArticleResult.asSuccess
          : null;

      return Result.success(
        PublishResult(
          articleId: articleId,
          publishedAt: DateTime.now(),
          wasScheduled: params.scheduledPublishAt != null,
          deletedDraftId: params.draft?.id,
          publishedArticle: publishedArticle,
        ),
      );
    } catch (e) {
      return Result.error(RepositoryException('Failed to publish article: $e'));
    }
  }

  /// Publish directly from draft
  Future<Result<PublishResult, RepositoryException>> publishFromDraft(
    String draftId, {
    required PublishVisibility visibility,
    required bool allowComments,
    bool isFeatured = false,
    DateTime? scheduledPublishAt,
    File? coverImage,
  }) async {
    // First, get the draft
    final getDraftResult = await _repository.getDraft(draftId);

    if (getDraftResult.isError) {
      return Result.error(getDraftResult.asError);
    }

    final draftModel = getDraftResult.asSuccess;
    if (draftModel == null) {
      return Result.error(const RepositoryException('Draft not found'));
    }

    // Convert to domain entity
    final draft = Draft(
      id: draftModel.id,
      title: draftModel.title,
      summary: draftModel.summary,
      content: draftModel.content,
      category: draftModel.category,
      authorId: draftModel.authorId,
      authorName: draftModel.authorName,
      tags: draftModel.tags,
      createdAt: draftModel.createdAt,
      lastModified: draftModel.lastModified,
      wordCount: draftModel.wordCount,
      readTimeMinutes: draftModel.readTimeMinutes,
      isAutoSaved: draftModel.isAutoSaved,
      coverImageUrl: draftModel.coverImageUrl,
    );

    // Create publish parameters
    final params = PublishArticleParams(
      draft: draft,
      visibility: visibility,
      allowComments: allowComments,
      isFeatured: isFeatured,
      scheduledPublishAt: scheduledPublishAt,
      coverImage: coverImage,
    );

    return await call(params);
  }

  /// Schedule article for future publishing
  Future<Result<PublishResult, RepositoryException>> schedulePublish(
    PublishArticleParams params,
    DateTime scheduledTime,
  ) async {
    if (scheduledTime.isBefore(DateTime.now())) {
      return Result.error(
        const RepositoryException('Scheduled time must be in the future'),
      );
    }

    final updatedParams = PublishArticleParams(
      draft: params.draft,
      title: params.title,
      summary: params.summary,
      content: params.content,
      category: params.category,
      authorId: params.authorId,
      authorName: params.authorName,
      tags: params.tags,
      visibility: params.visibility,
      allowComments: params.allowComments,
      isFeatured: params.isFeatured,
      coverImage: params.coverImage,
      scheduledPublishAt: scheduledTime,
    );

    return await call(updatedParams);
  }

  /// Update a published article
  Future<Result<void, RepositoryException>> updatePublishedArticle(
    String articleId,
    UpdateArticleParams params,
  ) async {
    try {
      // Check internet connectivity
      final hasConnection = await _repository.hasInternetConnection();
      if (!hasConnection) {
        return Result.error(
          const RepositoryException(
            'Internet connection required for updating',
          ),
        );
      }

      // Get the current article
      final getResult = await _repository.getPublishedArticle(articleId);
      if (getResult.isError) {
        return Result.error(getResult.asError);
      }

      final currentArticle = getResult.asSuccess;
      if (currentArticle == null) {
        return Result.error(const RepositoryException('Article not found'));
      }

      // Handle cover image update if provided
      String? newCoverImageUrl = currentArticle.coverImageUrl;
      if (params.coverImage != null) {
        final imageResult = await _repository.uploadCoverImage(
          params.coverImage!,
          articleId,
        );

        if (imageResult.isError) {
          return Result.error(
            RepositoryException(
              'Failed to upload new cover image: ${imageResult.asError.message}',
            ),
          );
        }

        newCoverImageUrl = imageResult.asSuccess;
      }

      // Create updated article
      final updatedArticle = currentArticle.copyWith(
        title: params.title ?? currentArticle.title,
        summary: params.summary ?? currentArticle.summary,
        content: params.content ?? currentArticle.content,
        category: params.category ?? currentArticle.category,
        tags: params.tags ?? currentArticle.tags,
        visibility: params.visibility ?? currentArticle.visibility,
        allowComments: params.allowComments ?? currentArticle.allowComments,
        isFeatured: params.isFeatured ?? currentArticle.isFeatured,
        coverImageUrl: newCoverImageUrl,
        lastModified: DateTime.now(),
      );

      return await _repository.updatePublishedArticle(updatedArticle);
    } catch (e) {
      return Result.error(RepositoryException('Failed to update article: $e'));
    }
  }

  /// Validate publishing parameters
  RepositoryException? _validateParams(PublishArticleParams params) {
    // Determine content source
    final title = params.title ?? params.draft?.title ?? '';
    final summary = params.summary ?? params.draft?.summary ?? '';
    final content = params.content ?? params.draft?.content ?? '';
    final category = params.category ?? params.draft?.category ?? '';
    final authorId = params.authorId ?? params.draft?.authorId ?? '';
    final authorName = params.authorName ?? params.draft?.authorName ?? '';
    final tags = params.tags ?? params.draft?.tags ?? [];

    // Validate required fields
    if (title.trim().isEmpty) {
      return const RepositoryException('Article title is required');
    }

    if (title.length > 200) {
      return const RepositoryException(
        'Article title cannot exceed 200 characters',
      );
    }

    if (summary.trim().isEmpty) {
      return const RepositoryException('Article summary is required');
    }

    if (summary.length > 500) {
      return const RepositoryException(
        'Article summary cannot exceed 500 characters',
      );
    }

    if (content.trim().isEmpty) {
      return const RepositoryException('Article content is required');
    }

    if (content.length < 100) {
      return const RepositoryException(
        'Article content must be at least 100 characters long',
      );
    }

    if (category.trim().isEmpty) {
      return const RepositoryException('Article category is required');
    }

    if (authorId.trim().isEmpty) {
      return const RepositoryException('Author ID is required');
    }

    if (authorName.trim().isEmpty) {
      return const RepositoryException('Author name is required');
    }

    if (tags.isEmpty) {
      return const RepositoryException('At least one tag is required');
    }

    if (tags.length > 10) {
      return const RepositoryException('Maximum 10 tags are allowed');
    }

    // Validate scheduled publish time
    if (params.scheduledPublishAt != null) {
      if (params.scheduledPublishAt!.isBefore(DateTime.now())) {
        return const RepositoryException(
          'Scheduled publish time must be in the future',
        );
      }

      // Don't allow scheduling more than 1 year in the future
      final oneYearFromNow = DateTime.now().add(const Duration(days: 365));
      if (params.scheduledPublishAt!.isAfter(oneYearFromNow)) {
        return const RepositoryException(
          'Cannot schedule more than 1 year in the future',
        );
      }
    }

    return null;
  }

  /// Create publish request from parameters
  PublishRequestModel _createPublishRequest(
    PublishArticleParams params,
    String? coverImageUrl,
  ) {
    return PublishRequestModel(
      title: params.title ?? params.draft!.title,
      summary: params.summary ?? params.draft!.summary,
      content: params.content ?? params.draft!.content,
      category: params.category ?? params.draft!.category,
      authorId: params.authorId ?? params.draft!.authorId,
      authorName: params.authorName ?? params.draft!.authorName,
      tags: params.tags ?? params.draft!.tags,
      visibility: params.visibility,
      allowComments: params.allowComments,
      isFeatured: params.isFeatured,
      coverImageUrl: coverImageUrl,
      draftId: params.draft?.id,
      scheduledPublishAt: params.scheduledPublishAt,
    );
  }
}

/// Parameters for publishing an article
class PublishArticleParams {
  const PublishArticleParams({
    this.draft,
    this.title,
    this.summary,
    this.content,
    this.category,
    this.authorId,
    this.authorName,
    this.tags,
    required this.visibility,
    required this.allowComments,
    this.isFeatured = false,
    this.coverImage,
    this.scheduledPublishAt,
  });
  final Draft? draft; // If publishing from existing draft

  // Override fields (if different from draft)
  final String? title;
  final String? summary;
  final String? content;
  final String? category;
  final String? authorId;
  final String? authorName;
  final List<String>? tags;

  // Publishing settings
  final PublishVisibility visibility;
  final bool allowComments;
  final bool isFeatured;
  final File? coverImage;
  final DateTime? scheduledPublishAt;
}

/// Parameters for updating a published article
class UpdateArticleParams {
  const UpdateArticleParams({
    this.title,
    this.summary,
    this.content,
    this.category,
    this.tags,
    this.visibility,
    this.allowComments,
    this.isFeatured,
    this.coverImage,
  });
  final String? title;
  final String? summary;
  final String? content;
  final String? category;
  final List<String>? tags;
  final PublishVisibility? visibility;
  final bool? allowComments;
  final bool? isFeatured;
  final File? coverImage;
}

/// Result of article publishing
class PublishResult {
  const PublishResult({
    required this.articleId,
    required this.publishedAt,
    required this.wasScheduled,
    this.deletedDraftId,
    this.publishedArticle,
  });
  final String articleId;
  final DateTime publishedAt;
  final bool wasScheduled;
  final String? deletedDraftId;
  final PublishedArticleModel? publishedArticle;
}
