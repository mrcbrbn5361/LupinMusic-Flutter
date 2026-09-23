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

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: LupinTheme.neonPink),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner / Hero
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [LupinTheme.surface, LupinTheme.surfaceLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: LupinTheme.glassBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚡ TRENDING CYBER CHARTS',
                        style: TextStyle(
                          color: LupinTheme.neonPink,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Discover Top Music & Releases',
                        style: TextStyle(
                          color: LupinTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (_trendingTracks.isNotEmpty) {
                            player.playTrack(_trendingTracks.first, newQueue: _trendingTracks);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LupinTheme.neonPink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 4),
                            Text('Play All'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Icon(Icons.graphic_eq, color: LupinTheme.neonPurple, size: 80),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            '🔥 Popular Track Stream',
            style: TextStyle(
              color: LupinTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _trendingTracks.length,
            itemBuilder: (ctx, index) {
              final track = _trendingTracks[index];
              final isCurrent = player.currentTrack?.id == track.id;
              return MusicCard(
                track: track,
                isPlaying: isCurrent,
                onTap: () {
                  player.playTrack(track, newQueue: _trendingTracks);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
