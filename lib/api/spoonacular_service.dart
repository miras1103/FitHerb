import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class SpoonacularService {
  static const String _ytKey = 'AIzaSyDTcTT8chAPIAxhOJAOOIjsAWgqbLjPCeU';
  static const String _ytUrl = 'https://www.googleapis.com/youtube/v3';
  static const String _prodUrl = 'https://world.openfoodfacts.org/api/v2/product';

  SpoonacularService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<http.Response> _get(Uri uri) async {
    Uri finalUri = uri;
    if (kIsWeb) {
      finalUri = Uri.parse('https://api.allorigins.win/get?url='
          '${Uri.encodeComponent(uri.toString())}');
    }
    final res = await _client.get(finalUri, headers: {
      'User-Agent': 'FitHerbApp - Version 1.3',
    });
    if (kIsWeb) {
      final wrapper = jsonDecode(res.body);
      return http.Response(wrapper['contents'], res.statusCode);
    }
    return res;
  }

  Future<List<YoutubeVideo>> queryVideos(String q) async {
    try {
      final uri = Uri.parse('$_ytUrl/search').replace(queryParameters: {
        'part': 'snippet',
        'q': '$q vitamins health benefits',
        'type': 'video',
        'maxResults': '10',
        'key': _ytKey,
      });
      final res = await _client.get(uri);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body);
      final List items = data['items'] ?? [];
      return items.map((i) => YoutubeVideo.fromJson(i)).toList();
    } catch (e) {
      return [];
    }
  }

  // Added queryRecipe back to fix the crash in RecipeDetailsPage
  Future<Map<String, dynamic>> queryRecipe(String id) async {
    try {
      final uri = Uri.parse('$_prodUrl/$id.json');
      final res = await _get(uri);
      final data = jsonDecode(res.body);
      return data['product'] as Map<String, dynamic>? ?? {};
    } catch (e) {
      return {};
    }
  }

  void close() => _client.close();
}
