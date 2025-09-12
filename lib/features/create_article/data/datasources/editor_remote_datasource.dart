
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shunno_prangon/core/error/exception.dart';
import '../models/draft_model.dart';
import '../models/publish_request_model.dart';

abstract class EditorRemoteDatasource {
  /// Save draft to Firestore
  Future<String> saveDraft(DraftModel draft);
  
  /// Get draft by ID from Firestore
  Future<DraftModel?> getDraft(String draftId);
  
  /// Get all drafts for current user
  Future<List<DraftModel>> getUserDrafts();
  
  /// Update existing draft
  Future<void> updateDraft(DraftModel draft);
  
  /// Delete draft from Firestore
  Future<void> deleteDraft(String draftId);
  
  /// Publish article from draft
  Future<String> publishArticle(PublishRequestModel publishRequest);
  
  /// Update published article
  Future<void> updatePublishedArticle(PublishedArticleModel article);
  
  /// Get published article by ID
  Future<PublishedArticleModel?> getPublishedArticle(String articleId);
  
  /// Get published articles for current user
  Future<List<PublishedArticleModel>> getUserPublishedArticles();
  
  /// Upload cover image
  Future<String> uploadCoverImage(File imageFile, String articleId);
  
  /// Delete cover image
  Future<void> deleteCoverImage(String imageUrl);
  
  /// Search drafts
  Future<List<DraftModel>> searchDrafts(String query);
  
  /// Get article analytics
  Future<Map<String, dynamic>> getArticleAnalytics(String articleId);
  
  /// Increment view count
  Future<void> incrementViewCount(String articleId);

  /// Stream user drafts for real-time updates
  Stream<List<DraftModel>> streamUserDrafts();
}

class EditorRemoteDatasourceImpl implements EditorRemoteDatasource {
  static const String _draftsCollection = 'drafts';
  static const String _articlesCollection = 'articles';
  static const String _analyticsCollection = 'analytics';
  static const String _imagesPath = 'article_images';
  
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  
  EditorRemoteDatasourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;
  
  String get _currentUserId {
    final user = _auth.currentUser;
    if (user == null) throw const AuthenticationException('User not authenticated');
    return user.uid;
  }
  
  @override
  Future<String> saveDraft(DraftModel draft) async {
    try {
      final docRef = _firestore.collection(_draftsCollection).doc();
      final draftWithId = draft.copyWith(
        id: docRef.id,
        authorId: _currentUserId,
      );
      
      await docRef.set(draftWithId.toFirestore());
      return docRef.id;
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to save draft: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error saving draft: $e');
    }
  }

  @override
  Future<DraftModel?> getDraft(String draftId) async {
    try {
      final doc = await _firestore.collection(_draftsCollection).doc(draftId).get();
      
      if (!doc.exists) return null;
      
      final draft = DraftModel.fromFirestore(doc);
      
      // Verify ownership
      if (draft.authorId != _currentUserId) {
        throw const PermissionException('Access denied to this draft');
      }
      
      return draft;
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get draft: ${e.message}');
    } catch (e) {
      if (e is PermissionException) rethrow;
      throw RemoteStorageException('Unexpected error getting draft: $e');
    }
  }

  @override
  Future<List<DraftModel>> getUserDrafts() async {
    try {
      final querySnapshot = await _firestore
          .collection(_draftsCollection)
          .where('authorId', isEqualTo: _currentUserId)
          .orderBy('lastModified', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => DraftModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get user drafts: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error getting user drafts: $e');
    }
  }
  
  @override
  Future<void> updateDraft(DraftModel draft) async {
    try {
      // Verify ownership before updating
      final existingDraft = await getDraft(draft.id);
      if (existingDraft == null) {
        throw const NotFoundException('Draft not found');
      }
      
      final updatedDraft = draft.copyWith(
        lastModified: DateTime.now(),
        wordCount: draft.calculateWordCount(),
        readTimeMinutes: draft.calculateReadTime(),
      );
      
      await _firestore
          .collection(_draftsCollection)
          .doc(draft.id)
          .update(updatedDraft.toFirestore());
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to update draft: ${e.message}');
    } catch (e) {
      if (e is NotFoundException || e is PermissionException) rethrow;
      throw RemoteStorageException('Unexpected error updating draft: $e');
    }
  }
  
  @override
  Future<void> deleteDraft(String draftId) async {
    try {
      // Verify ownership before deleting
      final draft = await getDraft(draftId);
      if (draft == null) {
        throw const NotFoundException('Draft not found');
      }
      
      // Delete cover image if exists
      if (draft.coverImageUrl != null) {
        await deleteCoverImage(draft.coverImageUrl!);
      }
      
      await _firestore.collection(_draftsCollection).doc(draftId).delete();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to delete draft: ${e.message}');
    } catch (e) {
      if (e is NotFoundException || e is PermissionException) rethrow;
      throw RemoteStorageException('Unexpected error deleting draft: $e');
    }
  }
  
  @override
  Future<String> publishArticle(PublishRequestModel publishRequest) async {
    try {
      final docRef = _firestore.collection(_articlesCollection).doc();
      final now = DateTime.now();
      
      // Calculate word count and reading time
      final wordCount = publishRequest.content.split(RegExp(r'\s+')).length;
      final readTime = (wordCount / 200).ceil();
      
      final article = PublishedArticleModel.fromPublishRequest(
        publishRequest,
        id: docRef.id,
        now: now,
        wordCount: wordCount,
        readTimeMinutes: readTime,
      );
      
      // Use batch write to ensure atomicity
      final batch = _firestore.batch();
      
      // Add article
      batch.set(docRef, article.toFirestore());
      
      // Delete draft if it exists
      if (publishRequest.draftId != null) {
        batch.delete(_firestore.collection(_draftsCollection).doc(publishRequest.draftId!));
      }
      
      // Initialize analytics document
      batch.set(
        _firestore.collection(_analyticsCollection).doc(docRef.id),
        {
          'articleId': docRef.id,
          'authorId': _currentUserId,
          'viewCount': 0,
          'likeCount': 0,
          'commentCount': 0,
          'shareCount': 0,
          'dailyViews': <String, int>{},
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        },
      );
      
      await batch.commit();
      return docRef.id;
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to publish article: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error publishing article: $e');
    }
  }
  
  @override
  Future<void> updatePublishedArticle(PublishedArticleModel article) async {
    try {
      // Verify ownership
      final existingArticle = await getPublishedArticle(article.id);
      if (existingArticle == null) {
        throw const NotFoundException('Article not found');
      }
      if (existingArticle.authorId != _currentUserId) {
        throw const PermissionException('Access denied to this article');
      }
      
      final updatedArticle = article.copyWith(
        lastModified: DateTime.now(),
        wordCount: article.content.split(RegExp(r'\s+')).length,
        readTimeMinutes: (article.content.split(RegExp(r'\s+')).length / 200).ceil(),
      );
      
      await _firestore
          .collection(_articlesCollection)
          .doc(article.id)
          .update(updatedArticle.toFirestore());
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to update article: ${e.message}');
    } catch (e) {
      if (e is NotFoundException || e is PermissionException) rethrow;
      throw RemoteStorageException('Unexpected error updating article: $e');
    }
  }
  
  @override
  Future<PublishedArticleModel?> getPublishedArticle(String articleId) async {
    try {
      final doc = await _firestore.collection(_articlesCollection).doc(articleId).get();
      
      if (!doc.exists) return null;
      
      return PublishedArticleModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get article: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error getting article: $e');
    }
  }
  
  @override
  Future<List<PublishedArticleModel>> getUserPublishedArticles() async {
    try {
      final querySnapshot = await _firestore
          .collection(_articlesCollection)
          .where('authorId', isEqualTo: _currentUserId)
          .orderBy('publishedAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get user articles: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error getting user articles: $e');
    }
  }
  
  @override
  Future<String> uploadCoverImage(File imageFile, String articleId) async {
    try {
      final fileName = '${articleId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(_imagesPath).child(_currentUserId).child(fileName);
      
      final uploadTask = ref.putFile(
        imageFile,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'articleId': articleId,
            'uploadedBy': _currentUserId,
          },
        ),
      );
      
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to upload image: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error uploading image: $e');
    }
  }
  
  @override
  Future<void> deleteCoverImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') {
        throw RemoteStorageException('Failed to delete image: ${e.message}');
      }
      // If object not found, consider it already deleted
    } catch (e) {
      throw RemoteStorageException('Unexpected error deleting image: $e');
    }
  }
  
  @override
  Future<List<DraftModel>> searchDrafts(String query) async {
    try {
      if (query.isEmpty) return getUserDrafts();
      
      // Firestore doesn't support full-text search, so we'll do client-side filtering
      // For production, consider using Algolia or ElasticSearch
      final allDrafts = await getUserDrafts();
      
      final lowerQuery = query.toLowerCase();
      return allDrafts.where((draft) {
        return draft.title.toLowerCase().contains(lowerQuery) ||
            draft.summary.toLowerCase().contains(lowerQuery) ||
            draft.content.toLowerCase().contains(lowerQuery) ||
            draft.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      }).toList();
    } catch (e) {
      throw RemoteStorageException('Failed to search drafts: $e');
    }
  }
  
  @override
  Future<Map<String, dynamic>> getArticleAnalytics(String articleId) async {
    try {
      // Verify ownership
      final article = await getPublishedArticle(articleId);
      if (article == null) {
        throw const NotFoundException('Article not found');
      }
      if (article.authorId != _currentUserId) {
        throw const PermissionException('Access denied to analytics');
      }
      
      final analyticsDoc = await _firestore
          .collection(_analyticsCollection)
          .doc(articleId)
          .get();
      
      if (!analyticsDoc.exists) {
        // Return default analytics if not found
        return {
          'articleId': articleId,
          'viewCount': article.viewCount,
          'likeCount': article.likeCount,
          'commentCount': article.commentCount,
          'shareCount': article.shareCount,
          'dailyViews': <String, int>{},
          'engagementRate': article.engagementRate,
        };
      }
      
      final data = analyticsDoc.data()!;
      data['engagementRate'] = article.engagementRate;
      return data;
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get analytics: ${e.message}');
    } catch (e) {
      if (e is NotFoundException || e is PermissionException) rethrow;
      throw RemoteStorageException('Unexpected error getting analytics: $e');
    }
  }
  
  @override
  Future<void> incrementViewCount(String articleId) async {
    try {
      final now = DateTime.now();
      final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      final batch = _firestore.batch();
      
      // Update article view count
      final articleRef = _firestore.collection(_articlesCollection).doc(articleId);
      batch.update(articleRef, {
        'viewCount': FieldValue.increment(1),
      });
      
      // Update analytics
      final analyticsRef = _firestore.collection(_analyticsCollection).doc(articleId);
      batch.update(analyticsRef, {
        'viewCount': FieldValue.increment(1),
        'dailyViews.$today': FieldValue.increment(1),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      await batch.commit();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to increment view count: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error incrementing view count: $e');
    }
  }
  
  // Additional utility methods
  
  /// Get drafts with pagination
  Future<List<DraftModel>> getUserDraftsPaginated({
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestore
          .collection(_draftsCollection)
          .where('authorId', isEqualTo: _currentUserId)
          .orderBy('lastModified', descending: true)
          .limit(limit);
      
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final querySnapshot = await query.get();
      
      return querySnapshot.docs
          .map((doc) => DraftModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get paginated drafts: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error getting paginated drafts: $e');
    }
  }
  
  /// Get articles by category
  Future<List<PublishedArticleModel>> getArticlesByCategory(
    String category, {
    int limit = 20,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(_articlesCollection)
          .where('category', isEqualTo: category)
          .where('visibility', isEqualTo: PublishVisibility.public.name)
          .where('status', isEqualTo: ArticleStatus.published.name)
          .orderBy('publishedAt', descending: true)
          .limit(limit)
          .get();
      
      return querySnapshot.docs
          .map((doc) => PublishedArticleModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw RemoteStorageException('Failed to get articles by category: ${e.message}');
    } catch (e) {
      throw RemoteStorageException('Unexpected error getting articles by category: $e');
    }
  }
  
  /// Stream user drafts for real-time updates
  Stream<List<DraftModel>> streamUserDrafts() {
    return _firestore
        .collection(_draftsCollection)
        .where('authorId', isEqualTo: _currentUserId)
        .orderBy('lastModified', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DraftModel.fromFirestore(doc))
            .toList());
  }
}
