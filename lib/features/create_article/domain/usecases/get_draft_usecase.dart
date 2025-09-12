import 'package:shunno_prangon/core/utils/result.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/editor_repository.dart';
import 'package:shunno_prangon/features/create_article/domain/repositories/repository_exception.dart';

class GetDraftUseCase {
  GetDraftUseCase(this._repository);

  final EditorRepository _repository;

  Future<Result<DraftModel?, RepositoryException>> call(String draftId) async {
    return _repository.getDraft(draftId);
  }
}
