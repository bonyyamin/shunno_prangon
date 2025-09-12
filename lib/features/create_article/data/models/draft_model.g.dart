// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DraftModelImpl _$$DraftModelImplFromJson(Map<String, dynamic> json) =>
    _$DraftModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      wordCount: (json['wordCount'] as num).toInt(),
      readTimeMinutes: (json['readTimeMinutes'] as num).toInt(),
      isAutoSaved: json['isAutoSaved'] as bool? ?? false,
      coverImageUrl: json['coverImageUrl'] as String?,
    );

Map<String, dynamic> _$$DraftModelImplToJson(_$DraftModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'category': instance.category,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastModified': instance.lastModified.toIso8601String(),
      'wordCount': instance.wordCount,
      'readTimeMinutes': instance.readTimeMinutes,
      'isAutoSaved': instance.isAutoSaved,
      'coverImageUrl': instance.coverImageUrl,
    };
