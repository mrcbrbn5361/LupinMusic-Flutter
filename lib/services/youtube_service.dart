import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/track.dart';

class YouTubeService {
  final YoutubeExplode _yt = YoutubeExplode();
  final Map<String, String> _urlCache = {};

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
    if (_urlCache.containsKey(videoId)) {
      return _urlCache[videoId];
    }

    try {
      // Use unthrottled mobile/TV clients (androidVr, tv, safari, ios) for instant sub-second resolution
      final manifest = await _yt.videos.streamsClient.getManifest(
        videoId,
        ytClients: const [
          YoutubeApiClient.androidVr,
          YoutubeApiClient.tv,
          YoutubeApiClient.safari,
          YoutubeApiClient.ios,
          YoutubeApiClient.android,
        ],
      ).timeout(const Duration(seconds: 4));

      final audioStreams = manifest.audioOnly;
      if (audioStreams.isNotEmpty) {
        // Prefer AAC / MP4 (M4A) streams for 100% native Windows, Android, macOS, and iOS compatibility
        // (Opus in WebM hangs or fails on standard Windows Media Foundation)
        final aacStreams = audioStreams.where((s) =>
            s.container.name.toLowerCase() == 'mp4' ||
            s.audioCodec.toLowerCase().contains('mp4a'));

        final selectedStream = aacStreams.isNotEmpty
            ? aacStreams.withHighestBitrate()
            : audioStreams.withHighestBitrate();

        final url = selectedStream.url.toString();
        _urlCache[videoId] = url;
        return url;
      }
    } catch (_) {
      // Fallback: standard resolution without client constraint
      try {
        final manifest = await _yt.videos.streamsClient
            .getManifest(videoId)
            .timeout(const Duration(seconds: 5));

        final audioStreams = manifest.audioOnly;
        if (audioStreams.isNotEmpty) {
          final aacStreams = audioStreams.where((s) =>
              s.container.name.toLowerCase() == 'mp4' ||
              s.audioCodec.toLowerCase().contains('mp4a'));

          final selectedStream = aacStreams.isNotEmpty
              ? aacStreams.withHighestBitrate()
              : audioStreams.withHighestBitrate();

          final url = selectedStream.url.toString();
          _urlCache[videoId] = url;
          return url;
        }
      } catch (_) {}
    }
    return null;
  }

  void dispose() {
    _yt.close();
  }
}
