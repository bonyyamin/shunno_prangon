import 'package:flutter/foundation.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';

enum EditorStatus {
  initial,
  loading,
  loaded,
  saving,
  saved,
  publishing,
  published,
  error,
}

@immutable
class EditorState {
  const EditorState({
    this.status = EditorStatus.initial,
    this.draft,
    this.errorMessage,
  });

  final EditorStatus status;
  final DraftModel? draft;
  final String? errorMessage;

  EditorState copyWith({
    EditorStatus? status,
    DraftModel? draft,
    String? errorMessage,
  }) {
    return EditorState(
      status: status ?? this.status,
      draft: draft ?? this.draft,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
