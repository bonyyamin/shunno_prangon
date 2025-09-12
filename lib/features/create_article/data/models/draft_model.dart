import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'draft_model.freezed.dart';
part 'draft_model.g.dart';

@freezed
class DraftModel with _$DraftModel {
  const factory DraftModel({
    required String id,
    required String title,
    required String summary,
    required String content,
    required String category,
    required String authorId,
    required String authorName,
    required List<String> tags,
    required DateTime createdAt,
    required DateTime lastModified,
    required int wordCount,
    required int readTimeMinutes,
    @Default(false) bool isAutoSaved,
    String? coverImageUrl,
  }) = _DraftModel;

  factory DraftModel.fromJson(Map<String, dynamic> json) =>
      _$DraftModelFromJson(json);

  // Factory constructor for Firestore documents
  factory DraftModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DraftModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastModified: (data['lastModified'] as Timestamp).toDate(),
      wordCount: data['wordCount'] ?? 0,
      readTimeMinutes: data['readTimeMinutes'] ?? 0,
      isAutoSaved: data['isAutoSaved'] ?? false,
      coverImageUrl: data['coverImageUrl'],
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
      'createdAt': Timestamp.fromDate(createdAt),
      'lastModified': Timestamp.fromDate(lastModified),
      'wordCount': wordCount,
      'readTimeMinutes': readTimeMinutes,
      'isAutoSaved': isAutoSaved,
      'coverImageUrl': coverImageUrl,
    };
  }
}

// Extension for additional functionality
extension DraftModelX on DraftModel {
  // Calculate reading time based on word count (average 200 words per minute)
  int calculateReadTime() {
    return (wordCount / 200).ceil();
  }

  // Count words in content
  int calculateWordCount() {
    return content.split(RegExp(r'\s+')).length;
  }

  // Create updated version with new modification time
  DraftModel withUpdatedTimestamp() {
    return copyWith(
      lastModified: DateTime.now(),
      wordCount: calculateWordCount(),
      readTimeMinutes: calculateReadTime(),
    );
  }

  // Check if draft is recent (modified within last 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    return now.difference(lastModified).inHours < 24;
  }

  // Format time ago string
  String get timeAgoText {
    final now = DateTime.now();
    final difference = now.difference(lastModified);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘন্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return '${lastModified.day}/${lastModified.month}/${lastModified.year}';
    }
  }
}