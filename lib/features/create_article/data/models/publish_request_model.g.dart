// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publish_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublishRequestModelImpl _$$PublishRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PublishRequestModelImpl(
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      visibility: $enumDecode(_$PublishVisibilityEnumMap, json['visibility']),
      allowComments: json['allowComments'] as bool,
      isFeatured: json['isFeatured'] as bool,
      coverImageUrl: json['coverImageUrl'] as String?,
      draftId: json['draftId'] as String?,
      scheduledPublishAt: json['scheduledPublishAt'] == null
          ? null
          : DateTime.parse(json['scheduledPublishAt'] as String),
      status: $enumDecodeNullable(_$ArticleStatusEnumMap, json['status']) ??
          ArticleStatus.published,
    );

Map<String, dynamic> _$$PublishRequestModelImplToJson(
        _$PublishRequestModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'category': instance.category,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'tags': instance.tags,
      'visibility': _$PublishVisibilityEnumMap[instance.visibility]!,
      'allowComments': instance.allowComments,
      'isFeatured': instance.isFeatured,
      'coverImageUrl': instance.coverImageUrl,
      'draftId': instance.draftId,
      'scheduledPublishAt': instance.scheduledPublishAt?.toIso8601String(),
      'status': _$ArticleStatusEnumMap[instance.status]!,
    };

const _$PublishVisibilityEnumMap = {
  PublishVisibility.public: 'public',
  PublishVisibility.unlisted: 'unlisted',
  PublishVisibility.private: 'private',
};

const _$ArticleStatusEnumMap = {
  ArticleStatus.draft: 'draft',
  ArticleStatus.published: 'published',
  ArticleStatus.archived: 'archived',
};

_$PublishedArticleModelImpl _$$PublishedArticleModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PublishedArticleModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      visibility: $enumDecode(_$PublishVisibilityEnumMap, json['visibility']),
      allowComments: json['allowComments'] as bool,
      isFeatured: json['isFeatured'] as bool,
      status: $enumDecode(_$ArticleStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      wordCount: (json['wordCount'] as num).toInt(),
      readTimeMinutes: (json['readTimeMinutes'] as num).toInt(),
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
      coverImageUrl: json['coverImageUrl'] as String?,
      draftId: json['draftId'] as String?,
      scheduledPublishAt: json['scheduledPublishAt'] == null
          ? null
          : DateTime.parse(json['scheduledPublishAt'] as String),
      relatedArticleIds: (json['relatedArticleIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PublishedArticleModelImplToJson(
        _$PublishedArticleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'category': instance.category,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'tags': instance.tags,
      'visibility': _$PublishVisibilityEnumMap[instance.visibility]!,
      'allowComments': instance.allowComments,
      'isFeatured': instance.isFeatured,
      'status': _$ArticleStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'publishedAt': instance.publishedAt.toIso8601String(),
      'lastModified': instance.lastModified.toIso8601String(),
      'wordCount': instance.wordCount,
      'readTimeMinutes': instance.readTimeMinutes,
      'viewCount': instance.viewCount,
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'coverImageUrl': instance.coverImageUrl,
      'draftId': instance.draftId,
      'scheduledPublishAt': instance.scheduledPublishAt?.toIso8601String(),
      'relatedArticleIds': instance.relatedArticleIds,
    };
