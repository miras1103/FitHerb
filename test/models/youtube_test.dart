import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/youtube_video.dart';

void main() {
  group('YouTube Video Model (Endterm Feature)', () {
    test('YoutubeVideo should be correctly instantiated from JSON', () {
      final json = {
        'id': 'dQw4w9WgXcQ',
        'title': 'How to grow herbs',
        'description': 'A helpful guide to growing herbs at home.',
        'thumbnailUrl': 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
      };

      final video = YoutubeVideo.fromJson(json);

      expect(video.id, 'dQw4w9WgXcQ');
      expect(video.title, 'How to grow herbs');
      expect(video.description, isNotEmpty);
      expect(video.thumbnailUrl, contains('dQw4w9WgXcQ'));
    });

    test('toJson should return a correct map', () {
      final video = YoutubeVideo(
        id: '123',
        title: 'Test Video',
        thumbnailUrl: 'thumb',
        description: 'description',
      );

      final json = video.toJson();

      expect(json['id'], '123');
      expect(json['title'], 'Test Video');
      expect(json['description'], 'description');
    });
  });
}
