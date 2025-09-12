// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'publish_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PublishRequestModel _$PublishRequestModelFromJson(Map<String, dynamic> json) {
  return _PublishRequestModel.fromJson(json);
}

/// @nodoc
mixin _$PublishRequestModel {
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  PublishVisibility get visibility => throw _privateConstructorUsedError;
  bool get allowComments => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  String? get draftId => throw _privateConstructorUsedError;
  DateTime? get scheduledPublishAt => throw _privateConstructorUsedError;
  ArticleStatus get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublishRequestModelCopyWith<PublishRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublishRequestModelCopyWith<$Res> {
  factory $PublishRequestModelCopyWith(
          PublishRequestModel value, $Res Function(PublishRequestModel) then) =
      _$PublishRequestModelCopyWithImpl<$Res, PublishRequestModel>;
  @useResult
  $Res call(
      {String title,
      String summary,
      String content,
      String category,
      String authorId,
      String authorName,
      List<String> tags,
      PublishVisibility visibility,
      bool allowComments,
      bool isFeatured,
      String? coverImageUrl,
      String? draftId,
      DateTime? scheduledPublishAt,
      ArticleStatus status});
}

/// @nodoc
class _$PublishRequestModelCopyWithImpl<$Res, $Val extends PublishRequestModel>
    implements $PublishRequestModelCopyWith<$Res> {
  _$PublishRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? category = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? tags = null,
    Object? visibility = null,
    Object? allowComments = null,
    Object? isFeatured = null,
    Object? coverImageUrl = freezed,
    Object? draftId = freezed,
    Object? scheduledPublishAt = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PublishVisibility,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      draftId: freezed == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArticleStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PublishRequestModelImplCopyWith<$Res>
    implements $PublishRequestModelCopyWith<$Res> {
  factory _$$PublishRequestModelImplCopyWith(_$PublishRequestModelImpl value,
          $Res Function(_$PublishRequestModelImpl) then) =
      __$$PublishRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String summary,
      String content,
      String category,
      String authorId,
      String authorName,
      List<String> tags,
      PublishVisibility visibility,
      bool allowComments,
      bool isFeatured,
      String? coverImageUrl,
      String? draftId,
      DateTime? scheduledPublishAt,
      ArticleStatus status});
}

/// @nodoc
class __$$PublishRequestModelImplCopyWithImpl<$Res>
    extends _$PublishRequestModelCopyWithImpl<$Res, _$PublishRequestModelImpl>
    implements _$$PublishRequestModelImplCopyWith<$Res> {
  __$$PublishRequestModelImplCopyWithImpl(_$PublishRequestModelImpl _value,
      $Res Function(_$PublishRequestModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? category = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? tags = null,
    Object? visibility = null,
    Object? allowComments = null,
    Object? isFeatured = null,
    Object? coverImageUrl = freezed,
    Object? draftId = freezed,
    Object? scheduledPublishAt = freezed,
    Object? status = null,
  }) {
    return _then(_$PublishRequestModelImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PublishVisibility,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      draftId: freezed == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArticleStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublishRequestModelImpl implements _PublishRequestModel {
  const _$PublishRequestModelImpl(
      {required this.title,
      required this.summary,
      required this.content,
      required this.category,
      required this.authorId,
      required this.authorName,
      required final List<String> tags,
      required this.visibility,
      required this.allowComments,
      required this.isFeatured,
      this.coverImageUrl,
      this.draftId,
      this.scheduledPublishAt,
      this.status = ArticleStatus.published})
      : _tags = tags;

  factory _$PublishRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublishRequestModelImplFromJson(json);

  @override
  final String title;
  @override
  final String summary;
  @override
  final String content;
  @override
  final String category;
  @override
  final String authorId;
  @override
  final String authorName;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final PublishVisibility visibility;
  @override
  final bool allowComments;
  @override
  final bool isFeatured;
  @override
  final String? coverImageUrl;
  @override
  final String? draftId;
  @override
  final DateTime? scheduledPublishAt;
  @override
  @JsonKey()
  final ArticleStatus status;

  @override
  String toString() {
    return 'PublishRequestModel(title: $title, summary: $summary, content: $content, category: $category, authorId: $authorId, authorName: $authorName, tags: $tags, visibility: $visibility, allowComments: $allowComments, isFeatured: $isFeatured, coverImageUrl: $coverImageUrl, draftId: $draftId, scheduledPublishAt: $scheduledPublishAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublishRequestModelImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.scheduledPublishAt, scheduledPublishAt) ||
                other.scheduledPublishAt == scheduledPublishAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      summary,
      content,
      category,
      authorId,
      authorName,
      const DeepCollectionEquality().hash(_tags),
      visibility,
      allowComments,
      isFeatured,
      coverImageUrl,
      draftId,
      scheduledPublishAt,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublishRequestModelImplCopyWith<_$PublishRequestModelImpl> get copyWith =>
      __$$PublishRequestModelImplCopyWithImpl<_$PublishRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublishRequestModelImplToJson(
      this,
    );
  }
}

abstract class _PublishRequestModel implements PublishRequestModel {
  const factory _PublishRequestModel(
      {required final String title,
      required final String summary,
      required final String content,
      required final String category,
      required final String authorId,
      required final String authorName,
      required final List<String> tags,
      required final PublishVisibility visibility,
      required final bool allowComments,
      required final bool isFeatured,
      final String? coverImageUrl,
      final String? draftId,
      final DateTime? scheduledPublishAt,
      final ArticleStatus status}) = _$PublishRequestModelImpl;

  factory _PublishRequestModel.fromJson(Map<String, dynamic> json) =
      _$PublishRequestModelImpl.fromJson;

  @override
  String get title;
  @override
  String get summary;
  @override
  String get content;
  @override
  String get category;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  List<String> get tags;
  @override
  PublishVisibility get visibility;
  @override
  bool get allowComments;
  @override
  bool get isFeatured;
  @override
  String? get coverImageUrl;
  @override
  String? get draftId;
  @override
  DateTime? get scheduledPublishAt;
  @override
  ArticleStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$PublishRequestModelImplCopyWith<_$PublishRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PublishedArticleModel _$PublishedArticleModelFromJson(
    Map<String, dynamic> json) {
  return _PublishedArticleModel.fromJson(json);
}

/// @nodoc
mixin _$PublishedArticleModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  PublishVisibility get visibility => throw _privateConstructorUsedError;
  bool get allowComments => throw _privateConstructorUsedError;
  bool get isFeatured => throw _privateConstructorUsedError;
  ArticleStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  int get readTimeMinutes => throw _privateConstructorUsedError;
  int get viewCount => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  int get shareCount => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;
  String? get draftId => throw _privateConstructorUsedError;
  DateTime? get scheduledPublishAt => throw _privateConstructorUsedError;
  List<String>? get relatedArticleIds => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PublishedArticleModelCopyWith<PublishedArticleModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublishedArticleModelCopyWith<$Res> {
  factory $PublishedArticleModelCopyWith(PublishedArticleModel value,
          $Res Function(PublishedArticleModel) then) =
      _$PublishedArticleModelCopyWithImpl<$Res, PublishedArticleModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String summary,
      String content,
      String category,
      String authorId,
      String authorName,
      List<String> tags,
      PublishVisibility visibility,
      bool allowComments,
      bool isFeatured,
      ArticleStatus status,
      DateTime createdAt,
      DateTime publishedAt,
      DateTime lastModified,
      int wordCount,
      int readTimeMinutes,
      int viewCount,
      int likeCount,
      int commentCount,
      int shareCount,
      String? coverImageUrl,
      String? draftId,
      DateTime? scheduledPublishAt,
      List<String>? relatedArticleIds});
}

/// @nodoc
class _$PublishedArticleModelCopyWithImpl<$Res,
        $Val extends PublishedArticleModel>
    implements $PublishedArticleModelCopyWith<$Res> {
  _$PublishedArticleModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? category = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? tags = null,
    Object? visibility = null,
    Object? allowComments = null,
    Object? isFeatured = null,
    Object? status = null,
    Object? createdAt = null,
    Object? publishedAt = null,
    Object? lastModified = null,
    Object? wordCount = null,
    Object? readTimeMinutes = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? coverImageUrl = freezed,
    Object? draftId = freezed,
    Object? scheduledPublishAt = freezed,
    Object? relatedArticleIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PublishVisibility,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArticleStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeMinutes: null == readTimeMinutes
          ? _value.readTimeMinutes
          : readTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      draftId: freezed == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      relatedArticleIds: freezed == relatedArticleIds
          ? _value.relatedArticleIds
          : relatedArticleIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PublishedArticleModelImplCopyWith<$Res>
    implements $PublishedArticleModelCopyWith<$Res> {
  factory _$$PublishedArticleModelImplCopyWith(
          _$PublishedArticleModelImpl value,
          $Res Function(_$PublishedArticleModelImpl) then) =
      __$$PublishedArticleModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String summary,
      String content,
      String category,
      String authorId,
      String authorName,
      List<String> tags,
      PublishVisibility visibility,
      bool allowComments,
      bool isFeatured,
      ArticleStatus status,
      DateTime createdAt,
      DateTime publishedAt,
      DateTime lastModified,
      int wordCount,
      int readTimeMinutes,
      int viewCount,
      int likeCount,
      int commentCount,
      int shareCount,
      String? coverImageUrl,
      String? draftId,
      DateTime? scheduledPublishAt,
      List<String>? relatedArticleIds});
}

/// @nodoc
class __$$PublishedArticleModelImplCopyWithImpl<$Res>
    extends _$PublishedArticleModelCopyWithImpl<$Res,
        _$PublishedArticleModelImpl>
    implements _$$PublishedArticleModelImplCopyWith<$Res> {
  __$$PublishedArticleModelImplCopyWithImpl(_$PublishedArticleModelImpl _value,
      $Res Function(_$PublishedArticleModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? category = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? tags = null,
    Object? visibility = null,
    Object? allowComments = null,
    Object? isFeatured = null,
    Object? status = null,
    Object? createdAt = null,
    Object? publishedAt = null,
    Object? lastModified = null,
    Object? wordCount = null,
    Object? readTimeMinutes = null,
    Object? viewCount = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? shareCount = null,
    Object? coverImageUrl = freezed,
    Object? draftId = freezed,
    Object? scheduledPublishAt = freezed,
    Object? relatedArticleIds = freezed,
  }) {
    return _then(_$PublishedArticleModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as PublishVisibility,
      allowComments: null == allowComments
          ? _value.allowComments
          : allowComments // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ArticleStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastModified: null == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
      readTimeMinutes: null == readTimeMinutes
          ? _value.readTimeMinutes
          : readTimeMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      shareCount: null == shareCount
          ? _value.shareCount
          : shareCount // ignore: cast_nullable_to_non_nullable
              as int,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      draftId: freezed == draftId
          ? _value.draftId
          : draftId // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledPublishAt: freezed == scheduledPublishAt
          ? _value.scheduledPublishAt
          : scheduledPublishAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      relatedArticleIds: freezed == relatedArticleIds
          ? _value._relatedArticleIds
          : relatedArticleIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PublishedArticleModelImpl implements _PublishedArticleModel {
  const _$PublishedArticleModelImpl(
      {required this.id,
      required this.title,
      required this.summary,
      required this.content,
      required this.category,
      required this.authorId,
      required this.authorName,
      required final List<String> tags,
      required this.visibility,
      required this.allowComments,
      required this.isFeatured,
      required this.status,
      required this.createdAt,
      required this.publishedAt,
      required this.lastModified,
      required this.wordCount,
      required this.readTimeMinutes,
      this.viewCount = 0,
      this.likeCount = 0,
      this.commentCount = 0,
      this.shareCount = 0,
      this.coverImageUrl,
      this.draftId,
      this.scheduledPublishAt,
      final List<String>? relatedArticleIds})
      : _tags = tags,
        _relatedArticleIds = relatedArticleIds;

  factory _$PublishedArticleModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublishedArticleModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String summary;
  @override
  final String content;
  @override
  final String category;
  @override
  final String authorId;
  @override
  final String authorName;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final PublishVisibility visibility;
  @override
  final bool allowComments;
  @override
  final bool isFeatured;
  @override
  final ArticleStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime publishedAt;
  @override
  final DateTime lastModified;
  @override
  final int wordCount;
  @override
  final int readTimeMinutes;
  @override
  @JsonKey()
  final int viewCount;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int commentCount;
  @override
  @JsonKey()
  final int shareCount;
  @override
  final String? coverImageUrl;
  @override
  final String? draftId;
  @override
  final DateTime? scheduledPublishAt;
  final List<String>? _relatedArticleIds;
  @override
  List<String>? get relatedArticleIds {
    final value = _relatedArticleIds;
    if (value == null) return null;
    if (_relatedArticleIds is EqualUnmodifiableListView)
      return _relatedArticleIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PublishedArticleModel(id: $id, title: $title, summary: $summary, content: $content, category: $category, authorId: $authorId, authorName: $authorName, tags: $tags, visibility: $visibility, allowComments: $allowComments, isFeatured: $isFeatured, status: $status, createdAt: $createdAt, publishedAt: $publishedAt, lastModified: $lastModified, wordCount: $wordCount, readTimeMinutes: $readTimeMinutes, viewCount: $viewCount, likeCount: $likeCount, commentCount: $commentCount, shareCount: $shareCount, coverImageUrl: $coverImageUrl, draftId: $draftId, scheduledPublishAt: $scheduledPublishAt, relatedArticleIds: $relatedArticleIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublishedArticleModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.allowComments, allowComments) ||
                other.allowComments == allowComments) &&
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.readTimeMinutes, readTimeMinutes) ||
                other.readTimeMinutes == readTimeMinutes) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.shareCount, shareCount) ||
                other.shareCount == shareCount) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.scheduledPublishAt, scheduledPublishAt) ||
                other.scheduledPublishAt == scheduledPublishAt) &&
            const DeepCollectionEquality()
                .equals(other._relatedArticleIds, _relatedArticleIds));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        summary,
        content,
        category,
        authorId,
        authorName,
        const DeepCollectionEquality().hash(_tags),
        visibility,
        allowComments,
        isFeatured,
        status,
        createdAt,
        publishedAt,
        lastModified,
        wordCount,
        readTimeMinutes,
        viewCount,
        likeCount,
        commentCount,
        shareCount,
        coverImageUrl,
        draftId,
        scheduledPublishAt,
        const DeepCollectionEquality().hash(_relatedArticleIds)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PublishedArticleModelImplCopyWith<_$PublishedArticleModelImpl>
      get copyWith => __$$PublishedArticleModelImplCopyWithImpl<
          _$PublishedArticleModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PublishedArticleModelImplToJson(
      this,
    );
  }
}

abstract class _PublishedArticleModel implements PublishedArticleModel {
  const factory _PublishedArticleModel(
      {required final String id,
      required final String title,
      required final String summary,
      required final String content,
      required final String category,
      required final String authorId,
      required final String authorName,
      required final List<String> tags,
      required final PublishVisibility visibility,
      required final bool allowComments,
      required final bool isFeatured,
      required final ArticleStatus status,
      required final DateTime createdAt,
      required final DateTime publishedAt,
      required final DateTime lastModified,
      required final int wordCount,
      required final int readTimeMinutes,
      final int viewCount,
      final int likeCount,
      final int commentCount,
      final int shareCount,
      final String? coverImageUrl,
      final String? draftId,
      final DateTime? scheduledPublishAt,
      final List<String>? relatedArticleIds}) = _$PublishedArticleModelImpl;

  factory _PublishedArticleModel.fromJson(Map<String, dynamic> json) =
      _$PublishedArticleModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get summary;
  @override
  String get content;
  @override
  String get category;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  List<String> get tags;
  @override
  PublishVisibility get visibility;
  @override
  bool get allowComments;
  @override
  bool get isFeatured;
  @override
  ArticleStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get publishedAt;
  @override
  DateTime get lastModified;
  @override
  int get wordCount;
  @override
  int get readTimeMinutes;
  @override
  int get viewCount;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  int get shareCount;
  @override
  String? get coverImageUrl;
  @override
  String? get draftId;
  @override
  DateTime? get scheduledPublishAt;
  @override
  List<String>? get relatedArticleIds;
  @override
  @JsonKey(ignore: true)
  _$$PublishedArticleModelImplCopyWith<_$PublishedArticleModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
