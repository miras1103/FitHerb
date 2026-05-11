import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'youtube_video.dart';

class BookmarkManager extends ChangeNotifier {
  final String? userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Recipe> _bookmarks = [];
  List<YoutubeVideo> _videoBookmarks = [];
  bool _isLoading = true;

  List<Recipe> get bookmarks => _bookmarks;
  List<YoutubeVideo> get videoBookmarks => _videoBookmarks;
  bool get isLoading => _isLoading;

  StreamSubscription? _bookmarksSubscription;
  StreamSubscription? _videosSubscription;

  BookmarkManager(this.userId) {
    if (userId != null) {
      _listenToFavorites();
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  String generateSafeId(String brand, String title) {
    final cleanBrand = brand.trim().toLowerCase();
    final cleanTitle = title.trim().toLowerCase();
    final rawId = '${cleanBrand}_$cleanTitle';
    return rawId.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
  }

  void _listenToFavorites() {
    _bookmarksSubscription?.cancel();
    _videosSubscription?.cancel();

    _bookmarksSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      _bookmarks = snapshot.docs.map((doc) {
        return Recipe.fromJson(doc.data()).copyWith(id: doc.id);
      }).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error listening to favorites: $error');
      _isLoading = false;
      notifyListeners();
    });

    _videosSubscription = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorite_videos')
        .snapshots()
        .listen((snapshot) {
      _videoBookmarks = snapshot.docs
          .map((doc) => YoutubeVideo.fromJson(doc.data()))
          .toList();
      notifyListeners();
    }, onError: (error) {
      debugPrint('Error listening to favorite videos: $error');
    });
  }

  @override
  void dispose() {
    _bookmarksSubscription?.cancel();
    _videosSubscription?.cancel();
    super.dispose();
  }

  // --- Витамины ---
  bool isFavorite(String brand, String title) {
    final targetId = generateSafeId(brand, title);
    return _bookmarks.any((r) => r.id == targetId);
  }

  Future<void> toggleBookmark(Recipe r) async {
    if (userId == null) return;
    final customId = generateSafeId(r.brand, r.title);
    final docRef = _firestore.collection('users').doc(userId).collection('favorites').doc(customId);

    if (isFavorite(r.brand, r.title)) {
      _bookmarks.removeWhere((item) => item.id == customId);
      notifyListeners();
      try { await docRef.delete(); } catch (e) { _listenToFavorites(); }
    } else {
      final newRecipe = r.copyWith(id: customId);
      _bookmarks.add(newRecipe);
      notifyListeners();
      try {
        final data = r.toJson();
        data['id'] = customId;
        await docRef.set(data);
      } catch (e) { _listenToFavorites(); }
    }
  }

  Future<void> removeBookmark(String id) async {
    if (userId == null) return;
    _bookmarks.removeWhere((item) => item.id == id);
    notifyListeners();
    try {
      await _firestore.collection('users').doc(userId).collection('favorites').doc(id).delete();
    } catch (e) { _listenToFavorites(); }
  }

  // --- Видео ---
  bool isVideoBookmarked(String id) {
    return _videoBookmarks.any((v) => v.id == id);
  }

  Future<void> toggleVideoBookmark(YoutubeVideo video) async {
    if (userId == null) return;
    
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorite_videos')
        .doc(video.id);

    if (isVideoBookmarked(video.id)) {
      _videoBookmarks.removeWhere((v) => v.id == video.id);
      notifyListeners();
      try {
        await docRef.delete();
      } catch (e) { _listenToFavorites(); }
    } else {
      _videoBookmarks.add(video);
      notifyListeners();
      try {
        await docRef.set(video.toJson());
      } catch (e) { _listenToFavorites(); }
    }
  }
}
