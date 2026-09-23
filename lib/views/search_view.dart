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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;
    final crossAxisCount = isMobile
        ? 2
        : (screenWidth > 1300 ? 6 : (screenWidth > 1050 ? 5 : 4));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content Header Search Bar
        Padding(
          padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, isMobile ? 12 : 20, isMobile ? 16 : 32, 14),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            height: isMobile ? 40 : 42,
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
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.search, color: LupinTheme.textMuted, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _performSearch,
                    style: TextStyle(color: Colors.white, fontSize: isMobile ? 12.5 : 13.5),
                    decoration: InputDecoration(
                      hintText: isMobile
                          ? 'Şarkı, sanatçı veya albüm ara...'
                          : 'Şarkı, sanatçı veya albüm ara... (Boşluk tuşu: Oynat/Duraklat)',
                      hintStyle: TextStyle(
                        color: LupinTheme.textDim,
                        fontSize: isMobile ? 12.5 : 13.5,
                      ),
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
            padding: EdgeInsets.fromLTRB(isMobile ? 16 : 32, 4, isMobile ? 16 : 32, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title matching Electron: 🔍 "ohal" için Arama Sonuçları
                Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '"$_currentQuery" için Arama Sonuçları',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 15 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 12 : 18),

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
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: isMobile ? 0.75 : 0.72,
                                crossAxisSpacing: isMobile ? 12 : 18,
                                mainAxisSpacing: isMobile ? 12 : 18,
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
