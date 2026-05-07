class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String description;

  const YoutubeVideo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
  });

  factory YoutubeVideo.fromJson(Map<String, dynamic> json) {
    // Check if it's coming from local storage (toJson) or API
    if (json.containsKey('thumbnailUrl')) {
      return YoutubeVideo(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
      );
    }

    final snippet = json['snippet'] as Map<String, dynamic>;
    final idData = json['id'] as Map<String, dynamic>;
    
    return YoutubeVideo(
      id: idData['videoId'] as String? ?? '',
      title: snippet['title'] as String? ?? '',
      description: snippet['description'] as String? ?? '',
      thumbnailUrl: (snippet['thumbnails']?['medium']?['url'] ?? 
                    snippet['thumbnails']?['default']?['url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
