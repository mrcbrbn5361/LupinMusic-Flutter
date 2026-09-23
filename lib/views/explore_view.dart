import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/track.dart';
import '../providers/player_provider.dart';
import '../services/youtube_service.dart';
import '../widgets/music_card.dart';
import '../theme/lupin_theme.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final YouTubeService _ytService = YouTubeService();
  List<Track> _trendingTracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    setState(() => _isLoading = true);
    final tracks = await _ytService.getTrendingTracks();
    if (mounted) {
      setState(() {
        _trendingTracks = tracks;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title matching Electron: 🔥 Keşfet — Popüler Parçalar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    '🔥 Keşfet — Popüler Parçalar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (_trendingTracks.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    player.playTrack(_trendingTracks.first, newQueue: _trendingTracks);
                  },
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Hepsini Oynat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LupinTheme.accentPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: LupinTheme.accentPink),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _trendingTracks.length,
                    itemBuilder: (ctx, index) {
                      final track = _trendingTracks[index];
                      final isCurrent = player.currentTrack?.id == track.id;

                      return MusicCard(
                        track: track,
                        isPlaying: isCurrent && player.isPlaying,
                        onTap: () {
                          player.playTrack(track, newQueue: _trendingTracks);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
