import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/track.dart';
import '../providers/player_provider.dart';
import '../services/youtube_service.dart';
import '../widgets/music_card.dart';
import '../theme/lupin_theme.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController =
      TextEditingController(text: 'ohal');
  final YouTubeService _ytService = YouTubeService();
  List<Track> _results = [];
  bool _isSearching = false;
  String _currentQuery = 'ohal';

  @override
  void initState() {
    super.initState();
    _performSearch('ohal');
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _isSearching = true;
      _currentQuery = query.trim();
    });
    final results = await _ytService.search(_currentQuery);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content Header Search Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xC018082C),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: LupinTheme.borderSubtle, width: 1.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: LupinTheme.textMuted, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _performSearch,
                    style: const TextStyle(color: Colors.white, fontSize: 13.5),
                    decoration: const InputDecoration(
                      hintText: 'Şarkı, sanatçı veya albüm ara... (Boşluk tuşu: Oynat/Duraklat)',
                      hintStyle: TextStyle(color: LupinTheme.textDim, fontSize: 13.5),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.clear, color: LupinTheme.textMuted, size: 16),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
              ],
            ),
          ),
        ),

        // Search Results Section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 4, 32, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title matching Electron: 🔍 "ohal" için Arama Sonuçları
                Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '"$_currentQuery" için Arama Sonuçları',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: _isSearching
                      ? const Center(
                          child: CircularProgressIndicator(color: LupinTheme.accentPink),
                        )
                      : _results.isEmpty
                          ? const Center(
                              child: Text(
                                'Sonuç bulunamadı',
                                style: TextStyle(color: LupinTheme.textSecondary),
                              ),
                            )
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 0.72,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _results.length,
                              itemBuilder: (ctx, index) {
                                final track = _results[index];
                                final isCurrent =
                                    player.currentTrack?.id == track.id;

                                return MusicCard(
                                  track: track,
                                  isPlaying: isCurrent && player.isPlaying,
                                  onTap: () {
                                    player.playTrack(track, newQueue: _results);
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
