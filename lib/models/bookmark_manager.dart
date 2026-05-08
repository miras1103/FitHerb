import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recipe.dart';
import 'youtube_video.dart';

class BookmarkManager extends ChangeNotifier {
  final String? userId;
  
  String get _bookmarkKey => userId != null ? 'vitaminBookmarks_$userId' : 'vitaminBookmarks_guest';
  String get _videoKey => userId != null ? 'videoBookmarks_$userId' : 'videoBookmarks_guest';
  
  List<Recipe> _bookmarks = [];
  List<YoutubeVideo> _videoBookmarks = [];
  bool _isLoading = true;

  List<Recipe> get bookmarks => _bookmarks;
  List<YoutubeVideo> get videoBookmarks => _videoBookmarks;
  bool get isLoading => _isLoading;

  BookmarkManager(this.userId) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load Vitamin Bookmarks
    final values = prefs.getStringList(_bookmarkKey) ?? [];
    _bookmarks = values
        .map((v) => jsonDecode(v) as Map<String, dynamic>)
        .map(Recipe.fromJson)
        .toList();

    // Load Video Bookmarks
    final videoValues = prefs.getStringList(_videoKey) ?? [];
    _videoBookmarks = videoValues
        .map((v) => YoutubeVideo.fromJson(jsonDecode(v)))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  // Vitamin Bookmarks
  Future<List<Recipe>> getBookmarks() async {
    if (_isLoading) await _load();
    return _bookmarks;
  }

  bool isBookmarked(String id) {
    return _bookmarks.any((r) => r.id == id);
  }

  Future<void> toggleBookmark(Recipe r) async {
    final index = _bookmarks.indexWhere((item) => item.id == r.id);
    if (index != -1) {
      _bookmarks.removeAt(index);
    } else {
      _bookmarks.add(r);
    }
    notifyListeners();
    await _save();
  }

  Future<void> removeBookmark(String id) async {
    _bookmarks.removeWhere((r) => r.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final values = _bookmarks.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_bookmarkKey, values);
  }

  // --- Video Bookmarks ---

  Future<List<YoutubeVideo>> getVideoBookmarks() async {
    if (_isLoading) await _load();
    return _videoBookmarks;
  }

  bool isVideoBookmarked(String id) {
    return _videoBookmarks.any((v) => v.id == id);
  }

  Future<void> toggleVideoBookmark(YoutubeVideo video) async {
    final index = _videoBookmarks.indexWhere((v) => v.id == video.id);
    if (index != -1) {
      _videoBookmarks.removeAt(index);
    } else {
      _videoBookmarks.add(video);
    }
    notifyListeners();
    await _saveVideos();
  }

  Future<void> _saveVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final values = _videoBookmarks.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList(_videoKey, values);
  }
}
