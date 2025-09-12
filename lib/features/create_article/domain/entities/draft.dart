import 'package:equatable/equatable.dart';

class Draft extends Equatable {
  const Draft({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.authorId,
    required this.authorName,
    required this.tags,
    required this.createdAt,
    required this.lastModified,
    required this.wordCount,
    required this.readTimeMinutes,
    this.isAutoSaved = false,
    this.coverImageUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String authorId;
  final String authorName;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime lastModified;
  final int wordCount;
  final int readTimeMinutes;
  final bool isAutoSaved;
  final String? coverImageUrl;

  /// Computed getters
  bool get hasContent => content.trim().isNotEmpty;
  
  bool get isReadyToPublish => title.trim().isNotEmpty && 
      content.trim().isNotEmpty && 
      category.isNotEmpty && 
      authorName.isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        content,
        category,
        authorId,
        authorName,
        tags,
        createdAt,
        lastModified,
        wordCount,
        readTimeMinutes,
        isAutoSaved,
        coverImageUrl,
      ];

  Draft copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? category,
    String? authorId,
    String? authorName,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? lastModified,
    int? wordCount,
    int? readTimeMinutes,
    bool? isAutoSaved,
    String? coverImageUrl,
  }) {
    return Draft(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      wordCount: wordCount ?? this.wordCount,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      isAutoSaved: isAutoSaved ?? this.isAutoSaved,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }

  Draft withUpdatedTimestamp() {
    return copyWith(
      lastModified: DateTime.now(),
      wordCount: calculateWordCount(),
      readTimeMinutes: calculateReadTime(),
    );
  }

  int calculateReadTime() {
    return (wordCount / 200).ceil();
  }

  int calculateWordCount() {
    return content.split(RegExp(r'\s+')).length;
  }
}
