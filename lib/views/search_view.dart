import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/track.dart';
import '../providers/player_provider.dart';
import '../services/youtube_service.dart';
import '../theme/lupin_theme.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final YouTubeService _ytService = YouTubeService();
  List<Track> _results = [];
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isSearching = true);
    final results = await _ytService.search(query);
    if (mounted) {
      setState(() {
        _results = results;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          // Search Input Bar
          Container(
            decoration: LupinTheme.glassDecoration(radius: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onSubmitted: _performSearch,
              style: const TextStyle(color: LupinTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search songs, artists, albums...',
                hintStyle: const TextStyle(color: LupinTheme.textSecondary),
                border: InputBorder.none,
                icon: const Icon(Icons.search, color: LupinTheme.neonPink),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: LupinTheme.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _results = []);
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_isSearching)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: LupinTheme.neonPink),
              ),
            )
          else if (_results.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, color: LupinTheme.textSecondary, size: 64),
                    SizedBox(height: 12),
                    Text(
                      'Search for your favorite tracks above',
                      style: TextStyle(color: LupinTheme.textSecondary, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (ctx, index) {
                  final track = _results[index];
                  final isCurrent = player.currentTrack?.id == track.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isCurrent ? LupinTheme.surfaceLight : LupinTheme.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrent ? LupinTheme.neonPink : LupinTheme.glassBorder,
                      ),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          track.thumbnailUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.music_note, color: LupinTheme.neonPurple),
                        ),
                      ),
                      title: Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent ? LupinTheme.neonPink : LupinTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: LupinTheme.textSecondary),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isCurrent && player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: LupinTheme.neonPink,
                          size: 32,
                        ),
                        onPressed: () {
                          // Play track and pass full search result list as queue in order!
                          player.playTrack(track, newQueue: _results);
                        },
                      ),
                      onTap: () {
                        player.playTrack(track, newQueue: _results);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
