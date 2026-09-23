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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final crossAxisCount = isMobile
        ? 2
        : (screenWidth > 1300 ? 6 : (screenWidth > 1050 ? 5 : 4));

    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, isMobile ? 16 : 24, isMobile ? 16 : 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title matching Electron: 🔥 Keşfet — Popüler Parçalar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🔥 Keşfet — Popüler Parçalar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (_trendingTracks.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () {
                    player.playTrack(_trendingTracks.first, newQueue: _trendingTracks);
                  },
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: Text(isMobile ? 'Oynat' : 'Hepsini Oynat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LupinTheme.accentPink,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 8 : 12,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
          SizedBox(height: isMobile ? 14 : 20),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: LupinTheme.accentPink),
                  )
                : GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: isMobile ? 0.75 : 0.72,
                      crossAxisSpacing: isMobile ? 12 : 18,
                      mainAxisSpacing: isMobile ? 12 : 18,
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
