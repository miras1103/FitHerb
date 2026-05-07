import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/spoonacular_service.dart';
import '../models/models.dart';
import '../providers.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _SearchAppBar(),
      body: VideoSearchSection(),
    );
  }
}

class VideoSearchSection extends ConsumerStatefulWidget {
  const VideoSearchSection({super.key});

  @override
  ConsumerState<VideoSearchSection> createState() => _VideoSearchSectionState();
}

class _VideoSearchSectionState extends ConsumerState<VideoSearchSection> {
  final SpoonacularService _service = SpoonacularService();
  final AppCache _appCache = AppCache();
  final SearchController _searchController = SearchController();
  
  final List<YoutubeVideo> _videos = [];
  List<String> _previousSearches = [];
  
  bool _loading = false;
  String? _errorMessage;
  bool _showBookmarks = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.close();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    final history = await _appCache.getPreviousSearches();
    if (!mounted) return;
    setState(() {
      _previousSearches = history;
    });
  }

  Future<void> _search(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      if (trimmedQuery.length >= 2) {
        await _appCache.addSearch(trimmedQuery);
        await _loadSearchHistory();
      }
      
      final results = await _service.queryVideos(trimmedQuery);
      if (!mounted) return;
      setState(() {
        _videos.clear();
        _videos.addAll(results);
        _errorMessage = _videos.isEmpty ? 'No videos found' : null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Search failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final bookmarkedVideos = bookmarkManager.videoBookmarks;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildTypePicker(),
          const SizedBox(height: 8),
          if (!_showBookmarks) ...[
            _buildSearchAnchor(),
            if (_loading) const LinearProgressIndicator(),
            if (_errorMessage != null) _buildMessage(_errorMessage!),
          ],
          Expanded(
            child: ListView(
              children: [
                if (_showBookmarks)
                  ...bookmarkedVideos.map((v) => _buildVideoTile(v, bookmarkManager))
                else
                  ..._videos.map((v) => _buildVideoTile(v, bookmarkManager)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypePicker() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment(value: false, label: Text('Search'), icon:
        Icon(Icons.search)),
        ButtonSegment(value: true, label: Text('Saved'), icon:
        Icon(Icons.bookmark)),
      ],
      selected: {_showBookmarks},
      onSelectionChanged: (val) {
        setState(() {
          _showBookmarks = val.first;
        });
      },
    );
  }

  Widget _buildSearchAnchor() {
    return SearchAnchor(
      searchController: _searchController,
      viewOnSubmitted: (value) {
        _searchController.closeView(value);
        _search(value);
      },
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (_) {
            controller.openView();
          },
          onSubmitted: (value) {
            _search(value);
          },
          leading: const Icon(Icons.search),
          trailing: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => controller.openView(),
            )
          ],
          hintText: 'Search health tips...',
        );
      },
      suggestionsBuilder: (context, controller) {
        return [
          StatefulBuilder(
            builder: (context, setInnerState) {
              if (_previousSearches.isEmpty) {
                return const ListTile(title: Text('No search history'));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: _previousSearches.map((search) {
                  return ListTile(
                    key: ValueKey(search),
                    title: Text(search),
                    leading: const Icon(Icons.history),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        await _appCache.removeSearch(search);
                        final history = await _appCache.getPreviousSearches();
                        if (mounted) {
                          setState(() {
                            _previousSearches = history;
                          });
                          setInnerState(() {});
                        }
                      },
                    ),
                    onTap: () {
                      controller.closeView(search);
                      _search(search);
                    },
                  );
                }).toList(),
              );
            },
          )
        ];
      },
    );
  }

  Widget _buildMessage(String m) => Padding(
    padding: const EdgeInsets.all(8), 
    child: Text(m)
  );

  Widget _buildVideoTile(YoutubeVideo video, BookmarkManager bookmarkManager) {
    final isSaved = bookmarkManager.isVideoBookmarked(video.id);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.network(video.thumbnailUrl, width: 100,
            fit: BoxFit.cover),
        title: Text(video.title, maxLines: 2),
        subtitle: const Text('YouTube Education', style: TextStyle(color:
        Colors.red)),
        trailing: IconButton(
          icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
          onPressed: () {
            bookmarkManager.toggleVideoBookmark(video);
          },
        ),
        onTap: () => launchUrl(Uri.parse('https://youtube.com/watch?v=${video.id}')),
      ),
    );
  }
}

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SearchAppBar();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) => AppBar(title: const Text('Vitamin TV'));
}
