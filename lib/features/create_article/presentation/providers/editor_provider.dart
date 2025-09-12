import 'package:flutter/material.dart';
import 'package:shunno_prangon/features/create_article/domain/usecases/delete_draft_usecase.dart';
import 'package:shunno_prangon/features/create_article/domain/usecases/get_all_drafts_usecase.dart';
import 'package:shunno_prangon/features/create_article/domain/usecases/get_draft_usecase.dart';
import 'package:shunno_prangon/features/create_article/domain/entities/draft.dart';
import 'package:shunno_prangon/features/create_article/domain/usecases/save_draft_usecase.dart';
import 'editor_state.dart';

class EditorProvider extends ChangeNotifier {
  EditorProvider({
    required this.saveDraftUseCase,
    required this.getDraftUseCase,
    required this.getAllDraftsUseCase,
    required this.deleteDraftUseCase,
  });

  final SaveDraftUseCase saveDraftUseCase;
  final GetDraftUseCase getDraftUseCase;
  final GetAllDraftsUseCase getAllDraftsUseCase;
  final DeleteDraftUseCase deleteDraftUseCase;

  EditorState _state = const EditorState();
  EditorState get state => _state;

  void _setState(EditorState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> loadDraft(String draftId) async {
    _setState(state.copyWith(status: EditorStatus.loading));
    final result = await getDraftUseCase(draftId);
    if (result.isSuccess) {
      _setState(state.copyWith(status: EditorStatus.loaded, draft: result.asSuccess));
    } else {
      _setState(state.copyWith(
        status: EditorStatus.error,
        errorMessage: result.asError.message,
      ));
    }
  }

  Future<void> saveDraft(String title, String content, String summary) async {
    _setState(state.copyWith(status: EditorStatus.saving));

    if (_state.draft == null) {
      _setState(state.copyWith(
          status: EditorStatus.error,
          errorMessage: 'Cannot save draft, no draft loaded.'));
      return;
    }

    final model = _state.draft!;
    final draftEntity = Draft(
      id: model.id,
      title: title,
      summary: summary,
      content: content,
      category: model.category,
      authorId: model.authorId,
      authorName: model.authorName,
      tags: model.tags,
      createdAt: model.createdAt,
      lastModified: model.lastModified,
      wordCount: model.wordCount,
      readTimeMinutes: model.readTimeMinutes,
      isAutoSaved: model.isAutoSaved,
      coverImageUrl: model.coverImageUrl,
    );

    final params = SaveDraftParams(draft: draftEntity);
    final result = await saveDraftUseCase(params);

    if (result.isSuccess) {
      _setState(state.copyWith(status: EditorStatus.saved));
    } else {
      _setState(state.copyWith(
        status: EditorStatus.error,
        errorMessage: result.asError.message,
      ));
    }
  }
}
