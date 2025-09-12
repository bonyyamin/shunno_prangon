import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';

part 'publish_request_model.freezed.dart';
part 'publish_request_model.g.dart';

enum PublishVisibility {
  @JsonValue('public')
  public,
  @JsonValue('unlisted')
  unlisted,
  @JsonValue('private')
  private,
}

enum ArticleStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
  @JsonValue('archived')
  archived,
}

@freezed
class PublishRequestModel with _$PublishRequestModel {
  const factory PublishRequestModel({
    required String title,
    required String summary,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
    required List<String> tags,
    required PublishVisibility visibility,
    required bool allowComments,
    required bool isFeatured,
    String? coverImageUrl,
    String? draftId,
    DateTime? scheduledPublishAt,
    @Default(ArticleStatus.published) ArticleStatus status,
  }) = _PublishRequestModel;

  factory PublishRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PublishRequestModelFromJson(json);

  // Create from draft
  factory PublishRequestModel.fromDraft(
    DraftModel draft, {
    required PublishVisibility visibility,
    required bool allowComments,
    required bool isFeatured,
    DateTime? scheduledPublishAt,
  }) {
    return PublishRequestModel(
      title: draft.title,
      summary: draft.summary,
      content: draft.content,
      category: draft.category,
      authorId: draft.authorId,
      authorName: draft.authorName,
      tags: draft.tags,
      visibility: visibility,
      allowComments: allowComments,
      isFeatured: isFeatured,
      coverImageUrl: draft.coverImageUrl,
      draftId: draft.id,
      scheduledPublishAt: scheduledPublishAt,
    );
  }
}

@freezed
class PublishedArticleModel with _$PublishedArticleModel {
  const factory PublishedArticleModel({
    required String id,
    required String title,
    required String summary,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
    required List<String> tags,
    required PublishVisibility visibility,
    required bool allowComments,
    required bool isFeatured,
    required ArticleStatus status,
    required DateTime createdAt,
    required DateTime publishedAt,
    required DateTime lastModified,
    required int wordCount,
    required int readTimeMinutes,
    @Default(0) int viewCount,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
    @Default(0) int shareCount,
    String? coverImageUrl,
    String? draftId,
    DateTime? scheduledPublishAt,
    List<String>? relatedArticleIds,
  }) = _PublishedArticleModel;

  factory PublishedArticleModel.fromJson(Map<String, dynamic> json) =>
      _$PublishedArticleModelFromJson(json);

  // Factory constructor for Firestore documents
  factory PublishedArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PublishedArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      visibility: PublishVisibility.values.firstWhere(
        (v) => v.name == data['visibility'],
        orElse: () => PublishVisibility.public,
      ),
      allowComments: data['allowComments'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      status: ArticleStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => ArticleStatus.published,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      publishedAt: (data['publishedAt'] as Timestamp).toDate(),
      lastModified: (data['lastModified'] as Timestamp).toDate(),
      wordCount: data['wordCount'] ?? 0,
      readTimeMinutes: data['readTimeMinutes'] ?? 0,
      viewCount: data['viewCount'] ?? 0,
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      shareCount: data['shareCount'] ?? 0,
      coverImageUrl: data['coverImageUrl'],
      draftId: data['draftId'],
      scheduledPublishAt: data['scheduledPublishAt'] != null
          ? (data['scheduledPublishAt'] as Timestamp).toDate()
          : null,
      relatedArticleIds: data['relatedArticleIds'] != null
          ? List<String>.from(data['relatedArticleIds'])
          : null,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      'authorId': authorId,
      'authorName': authorName,
      'tags': tags,
      'visibility': visibility.name,
      'allowComments': allowComments,
      'isFeatured': isFeatured,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'publishedAt': Timestamp.fromDate(publishedAt),
      'lastModified': Timestamp.fromDate(lastModified),
      'wordCount': wordCount,
      'readTimeMinutes': readTimeMinutes,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'coverImageUrl': coverImageUrl,
      'draftId': draftId,
      'scheduledPublishAt': scheduledPublishAt != null
          ? Timestamp.fromDate(scheduledPublishAt!)
          : null,
      'relatedArticleIds': relatedArticleIds,
    };
  }
  factory PublishedArticleModel.fromPublishRequest(
    PublishRequestModel request, {
    required String id,
    required DateTime now,
    int wordCount = 0,
    int readTimeMinutes = 0,
  }) {
    return PublishedArticleModel(
      id: id,
      title: request.title,
      summary: request.summary,
      content: request.content,
      category: request.category,
      authorId: request.authorId,
      authorName: request.authorName,
      tags: request.tags,
      visibility: request.visibility,
      allowComments: request.allowComments,
      isFeatured: request.isFeatured,
      status: request.status,
      createdAt: now,
      publishedAt: request.scheduledPublishAt ?? now,
      lastModified: now,
      wordCount: wordCount,
      readTimeMinutes: readTimeMinutes,
      coverImageUrl: request.coverImageUrl,
      draftId: request.draftId,
      scheduledPublishAt: request.scheduledPublishAt,
    );
  }
}

// Extension for additional functionality
extension PublishedArticleModelX on PublishedArticleModel {
  // Check if article is publicly visible
  bool get isPublic => visibility == PublishVisibility.public;

  // Check if article is scheduled for future publishing
  bool get isScheduled =>
      scheduledPublishAt != null && scheduledPublishAt!.isAfter(DateTime.now());

  // Calculate engagement rate
  double get engagementRate {
    if (viewCount == 0) return 0.0;
    final totalEngagements = likeCount + commentCount + shareCount;
    return (totalEngagements / viewCount) * 100;
  }

  // Format publish time
  String get publishTimeText {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return '${publishedAt.day}/${publishedAt.month}/${publishedAt.year}';
    }
  }
}