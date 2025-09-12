// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DraftModel _$DraftModelFromJson(Map<String, dynamic> json) {
  return _DraftModel.fromJson(json);
}

/// @nodoc
mixin _$DraftModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastModified => throw _privateConstructorUsedError;
  int get wordCount => throw _privateConstructorUsedError;
  int get readTimeMinutes => throw _privateConstructorUsedError;
  bool get isAutoSaved => throw _privateConstructorUsedError;
  String? get coverImageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DraftModelCopyWith<DraftModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftModelCopyWith<$Res> {
  factory $DraftModelCopyWith(
          DraftModel value, $Res Function(DraftModel) then) =
      _$DraftModelCopyWithImpl<$Res, DraftModel>;
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
      DateTime createdAt,
      DateTime lastModified,
      int wordCount,
      int readTimeMinutes,
      bool isAutoSaved,
      String? coverImageUrl});
}

/// @nodoc
class _$DraftModelCopyWithImpl<$Res, $Val extends DraftModel>
    implements $DraftModelCopyWith<$Res> {
  _$DraftModelCopyWithImpl(this._value, this._then);

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
    Object? createdAt = null,
    Object? lastModified = null,
    Object? wordCount = null,
    Object? readTimeMinutes = null,
    Object? isAutoSaved = null,
    Object? coverImageUrl = freezed,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
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
      isAutoSaved: null == isAutoSaved
          ? _value.isAutoSaved
          : isAutoSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DraftModelImplCopyWith<$Res>
    implements $DraftModelCopyWith<$Res> {
  factory _$$DraftModelImplCopyWith(
          _$DraftModelImpl value, $Res Function(_$DraftModelImpl) then) =
      __$$DraftModelImplCopyWithImpl<$Res>;
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
      DateTime createdAt,
      DateTime lastModified,
      int wordCount,
      int readTimeMinutes,
      bool isAutoSaved,
      String? coverImageUrl});
}

/// @nodoc
class __$$DraftModelImplCopyWithImpl<$Res>
    extends _$DraftModelCopyWithImpl<$Res, _$DraftModelImpl>
    implements _$$DraftModelImplCopyWith<$Res> {
  __$$DraftModelImplCopyWithImpl(
      _$DraftModelImpl _value, $Res Function(_$DraftModelImpl) _then)
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
    Object? createdAt = null,
    Object? lastModified = null,
    Object? wordCount = null,
    Object? readTimeMinutes = null,
    Object? isAutoSaved = null,
    Object? coverImageUrl = freezed,
  }) {
    return _then(_$DraftModelImpl(
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
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
      isAutoSaved: null == isAutoSaved
          ? _value.isAutoSaved
          : isAutoSaved // ignore: cast_nullable_to_non_nullable
              as bool,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DraftModelImpl implements _DraftModel {
  const _$DraftModelImpl(
      {required this.id,
      required this.title,
      required this.summary,
      required this.content,
      required this.category,
      required this.authorId,
      required this.authorName,
      required final List<String> tags,
      required this.createdAt,
      required this.lastModified,
      required this.wordCount,
      required this.readTimeMinutes,
      this.isAutoSaved = false,
      this.coverImageUrl})
      : _tags = tags;

  factory _$DraftModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DraftModelImplFromJson(json);

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
  final DateTime createdAt;
  @override
  final DateTime lastModified;
  @override
  final int wordCount;
  @override
  final int readTimeMinutes;
  @override
  @JsonKey()
  final bool isAutoSaved;
  @override
  final String? coverImageUrl;

  @override
  String toString() {
    return 'DraftModel(id: $id, title: $title, summary: $summary, content: $content, category: $category, authorId: $authorId, authorName: $authorName, tags: $tags, createdAt: $createdAt, lastModified: $lastModified, wordCount: $wordCount, readTimeMinutes: $readTimeMinutes, isAutoSaved: $isAutoSaved, coverImageUrl: $coverImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftModelImpl &&
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
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.readTimeMinutes, readTimeMinutes) ||
                other.readTimeMinutes == readTimeMinutes) &&
            (identical(other.isAutoSaved, isAutoSaved) ||
                other.isAutoSaved == isAutoSaved) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      summary,
      content,
      category,
      authorId,
      authorName,
      const DeepCollectionEquality().hash(_tags),
      createdAt,
      lastModified,
      wordCount,
      readTimeMinutes,
      isAutoSaved,
      coverImageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftModelImplCopyWith<_$DraftModelImpl> get copyWith =>
      __$$DraftModelImplCopyWithImpl<_$DraftModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DraftModelImplToJson(
      this,
    );
  }
}

abstract class _DraftModel implements DraftModel {
  const factory _DraftModel(
      {required final String id,
      required final String title,
      required final String summary,
      required final String content,
      required final String category,
      required final String authorId,
      required final String authorName,
      required final List<String> tags,
      required final DateTime createdAt,
      required final DateTime lastModified,
      required final int wordCount,
      required final int readTimeMinutes,
      final bool isAutoSaved,
      final String? coverImageUrl}) = _$DraftModelImpl;

  factory _DraftModel.fromJson(Map<String, dynamic> json) =
      _$DraftModelImpl.fromJson;

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
  DateTime get createdAt;
  @override
  DateTime get lastModified;
  @override
  int get wordCount;
  @override
  int get readTimeMinutes;
  @override
  bool get isAutoSaved;
  @override
  String? get coverImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$DraftModelImplCopyWith<_$DraftModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
