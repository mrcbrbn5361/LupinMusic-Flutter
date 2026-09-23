import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/lupin_theme.dart';
import 'animated_equalizer.dart';

class PlayerBar extends StatefulWidget {
  final VoidCallback onOpenQueue;

  const PlayerBar({Key? key, required this.onOpenQueue}) : super(key: key);

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  double? _dragPosition;
  bool _isLiked = false;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString();
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final track = player.currentTrack;

    final position = player.position;
    final duration = player.duration;

    final currentSeconds = _dragPosition ?? position.inSeconds.toDouble();
    final maxSeconds = duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;

    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: LupinTheme.bgPlayer,
        border: Border(
          top: BorderSide(color: LupinTheme.borderSubtle, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Left: Track Info
          SizedBox(
            width: 280,
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: LupinTheme.borderSubtle),
                    color: const Color(0xFF17072A),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: track != null
                        ? Image.network(
                            track.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(Icons.music_note, color: LupinTheme.accentPink),
                          )
                        : Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) =>
                                const Icon(Icons.music_note, color: LupinTheme.accentPink),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track != null ? track.title : 'Lupin Music',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LupinTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        track != null ? track.artist : 'Bir şarkı seçin ve çalmaya başlayın',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LupinTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_border,
                    color: _isLiked ? LupinTheme.accentPink : LupinTheme.textMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _isLiked = !_isLiked);
                  },
                ),
              ],
            ),
          ),

          // Center: Playback Controls & Progress Bar
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button Controls Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: player.isShuffle ? LupinTheme.accentPink : LupinTheme.textSecondary,
                        size: 18,
                      ),
                      onPressed: player.toggleShuffle,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: LupinTheme.textSecondary,
                        size: 22,
                      ),
                      onPressed: player.previousTrack,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LupinTheme.neonGradient,
                        boxShadow: const [
                          BoxShadow(
                            color: LupinTheme.accentPinkGlow,
                            blurRadius: 16,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: player.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                player.isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                        onPressed: player.togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: LupinTheme.textSecondary,
                        size: 22,
                      ),
                      onPressed: player.nextTrack,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: player.isRepeat ? LupinTheme.accentPink : LupinTheme.textSecondary,
                        size: 18,
                      ),
                      onPressed: player.toggleRepeat,
                    ),
                  ],
                ),

                // Scrub / Progress Bar Row
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        _formatDuration(position),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: LupinTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          activeTrackColor: LupinTheme.accentPink,
                          inactiveTrackColor: Colors.white.withOpacity(0.12),
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        ),
                        child: Slider(
                          value: currentSeconds.clamp(0.0, maxSeconds),
                          max: maxSeconds,
                          onChanged: (val) {
                            setState(() => _dragPosition = val);
                          },
                          onChangeEnd: (val) {
                            player.seek(Duration(seconds: val.toInt()));
                            setState(() => _dragPosition = null);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _formatDuration(duration),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: LupinTheme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: Equalizer Visualizer, Queue, Volume
          SizedBox(
            width: 260,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Live Neon Equalizer
                AnimatedEqualizerBars(isPlaying: player.isPlaying),
                const SizedBox(width: 16),

                // Queue Toggle
                IconButton(
                  icon: const Icon(Icons.queue_music, color: LupinTheme.textSecondary, size: 20),
                  onPressed: widget.onOpenQueue,
                ),
                const SizedBox(width: 8),

                // Volume
                IconButton(
                  icon: Icon(
                    player.isMuted ? Icons.volume_off : Icons.volume_up,
                    color: LupinTheme.textSecondary,
                    size: 19,
                  ),
                  onPressed: player.toggleMute,
                ),
                SizedBox(
                  width: 85,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      activeTrackColor: LupinTheme.accentPink,
                      inactiveTrackColor: Colors.white.withOpacity(0.15),
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                    ),
                    child: Slider(
                      value: player.volume,
                      onChanged: player.setVolume,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
