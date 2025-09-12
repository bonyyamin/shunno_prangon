
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shunno_prangon/features/create_article/data/models/draft_model.dart';
import 'package:shunno_prangon/features/create_article/data/models/publish_request_model.dart';

abstract class EditorLocalDatasource {
  Future<void> saveDraft(DraftModel draft);
  Future<DraftModel?> getDraft(String draftId);
  Future<List<DraftModel>> getAllDrafts();
  Future<void> deleteDraft(String draftId);
  Future<void> autoSaveDraftContent({
    required String draftId,
    required String title,
    required String content,
    required String summary,
  });
  Future<Map<String, String>?> getAutoSavedContent(String draftId);
  Future<void> cachePublishedArticle(PublishedArticleModel article);
  Future<PublishedArticleModel?> getCachedArticle(String articleId);
  Future<List<PublishedArticleModel>> getAllCachedArticles();
  Future<void> clearCache();
  Future<Map<String, int>> getStorageStats();
  Future<bool> needsSync();
}

class EditorLocalDatasourceImpl implements EditorLocalDatasource {
  final SharedPreferences sharedPreferences;

  EditorLocalDatasourceImpl({required this.sharedPreferences});

  static const _draftPrefix = 'draft_';
  static const _autoSavePrefix = 'autosave_';
  static const _publishedArticlePrefix = 'published_article_';

  @override
  Future<void> saveDraft(DraftModel draft) async {
    final key = '$_draftPrefix${draft.id}';
    final draftJson = jsonEncode(draft.toJson());
    await sharedPreferences.setString(key, draftJson);
  }

  @override
  Future<DraftModel?> getDraft(String draftId) async {
    final key = '$_draftPrefix$draftId';
    final draftJson = sharedPreferences.getString(key);
    if (draftJson != null) {
      return DraftModel.fromJson(jsonDecode(draftJson));
    }
    return null;
  }

  @override
  Future<List<DraftModel>> getAllDrafts() async {
    final keys = sharedPreferences.getKeys();
    final draftKeys = keys.where((key) => key.startsWith(_draftPrefix));
    final drafts = <DraftModel>[];
    for (final key in draftKeys) {
      final draftJson = sharedPreferences.getString(key);
      if (draftJson != null) {
        drafts.add(DraftModel.fromJson(jsonDecode(draftJson)));
      }
    }
    return drafts;
  }

  @override
  Future<void> deleteDraft(String draftId) async {
    final key = '$_draftPrefix$draftId';
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> autoSaveDraftContent({
    required String draftId,
    required String title,
    required String content,
    required String summary,
  }) async {
    final key = '$_autoSavePrefix$draftId';
    final autoSaveData = {
      'title': title,
      'content': content,
      'summary': summary,
    };
    await sharedPreferences.setString(key, jsonEncode(autoSaveData));
  }

  @override
  Future<Map<String, String>?> getAutoSavedContent(String draftId) async {
    final key = '$_autoSavePrefix$draftId';
    final autoSaveJson = sharedPreferences.getString(key);
    if (autoSaveJson != null) {
      return Map<String, String>.from(jsonDecode(autoSaveJson));
    }
    return null;
  }

  @override
  Future<void> cachePublishedArticle(PublishedArticleModel article) async {
    final key = '$_publishedArticlePrefix${article.id}';
    final articleJson = jsonEncode(article.toJson());
    await sharedPreferences.setString(key, articleJson);
  }

  @override
  Future<PublishedArticleModel?> getCachedArticle(String articleId) async {
    final key = '$_publishedArticlePrefix$articleId';
    final articleJson = sharedPreferences.getString(key);
    if (articleJson != null) {
      return PublishedArticleModel.fromJson(jsonDecode(articleJson));
    }
    return null;
  }

  @override
  Future<List<PublishedArticleModel>> getAllCachedArticles() async {
    final keys = sharedPreferences.getKeys();
    final articleKeys = keys.where((key) => key.startsWith(_publishedArticlePrefix));
    final articles = <PublishedArticleModel>[];
    for (final key in articleKeys) {
      final articleJson = sharedPreferences.getString(key);
      if (articleJson != null) {
        articles.add(PublishedArticleModel.fromJson(jsonDecode(articleJson)));
      }
    }
    return articles;
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_draftPrefix) ||
          key.startsWith(_autoSavePrefix) ||
          key.startsWith(_publishedArticlePrefix)) {
        await sharedPreferences.remove(key);
      }
    }
  }

  @override
  Future<Map<String, int>> getStorageStats() async {
    final keys = sharedPreferences.getKeys();
    final draftCount = keys.where((key) => key.startsWith(_draftPrefix)).length;
    final articleCount = keys.where((key) => key.startsWith(_publishedArticlePrefix)).length;
    return {
      'drafts': draftCount,
      'articles': articleCount,
    };
  }

  @override
  Future<bool> needsSync() async {
    // This is a simplified implementation. A real implementation would involve
    // tracking which local items have not been synced with the remote.
    return false;
  }
}
