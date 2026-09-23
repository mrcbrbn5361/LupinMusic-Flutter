import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/track.dart';

class YouTubeService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<Track>> search(String query) async {
    try {
      final searchList = await _yt.search.search(query);
      return searchList.map((video) {
        return Track(
          id: video.id.value,
          title: video.title,
          artist: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
          duration: video.duration ?? Duration.zero,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Track>> getTrendingTracks() async {
    return search('trending music 2026');
  }

  Future<String?> getAudioStreamUrl(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      return audioStream.url.toString();
    } catch (e) {
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
