import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/lupin_theme.dart';
import 'equalizer_widget.dart';

class PlayerBar extends StatefulWidget {
  final VoidCallback onOpenQueue;

  const PlayerBar({Key? key, required this.onOpenQueue}) : super(key: key);

  @override
  State<PlayerBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<PlayerBar> {
  double? _dragPosition;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _showEqModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: EqualizerWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final track = player.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final position = player.position;
    final duration = player.duration;

    final currentSeconds = _dragPosition ?? position.inSeconds.toDouble();
    final maxSeconds = duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0;

    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: LupinTheme.glassDecoration(radius: 20),
      child: Column(
        children: [
          // Scrub Slider bar
          SizedBox(
            height: 12,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                activeTrackColor: LupinTheme.neonPink,
                inactiveTrackColor: LupinTheme.surfaceLight,
                thumbColor: LupinTheme.neonPurple,
                overlayColor: LupinTheme.neonPink.withOpacity(0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: currentSeconds.clamp(0.0, maxSeconds),
                max: maxSeconds,
                onChanged: (val) {
                  setState(() {
                    _dragPosition = val;
                  });
                },
                onChangeEnd: (val) {
                  player.seek(Duration(seconds: val.toInt()));
                  setState(() {
                    _dragPosition = null;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Track Image & Details
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    track.thumbnailUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.music_note, color: LupinTheme.neonPink),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LupinTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            track.artist,
                            style: const TextStyle(color: LupinTheme.textSecondary, fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                            style: const TextStyle(color: LupinTheme.neonPurple, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Controls
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color: player.isShuffle ? LupinTheme.neonPink : LupinTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: player.toggleShuffle,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: LupinTheme.textPrimary),
                  onPressed: player.previousTrack,
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [LupinTheme.neonPink, LupinTheme.neonPurple],
                    ),
                  ),
                  child: IconButton(
                    icon: player.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Icon(
                            player.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                    onPressed: player.togglePlayPause,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: LupinTheme.textPrimary),
                  onPressed: player.nextTrack,
                ),
                IconButton(
                  icon: Icon(
                    Icons.repeat,
                    color: player.isRepeat ? LupinTheme.neonPink : LupinTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: player.toggleRepeat,
                ),

                const SizedBox(width: 8),

                // Volume & EQ
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        player.isMuted ? Icons.volume_off : Icons.volume_up,
                        color: LupinTheme.textSecondary,
                        size: 20,
                      ),
                      onPressed: player.toggleMute,
                    ),
                    SizedBox(
                      width: 70,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 3,
                          activeTrackColor: LupinTheme.neonCyan,
                          inactiveTrackColor: LupinTheme.surfaceLight,
                          thumbColor: LupinTheme.neonCyan,
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

                IconButton(
                  icon: const Icon(Icons.tune, color: LupinTheme.neonPurple, size: 22),
                  onPressed: () => _showEqModal(context),
                ),
                IconButton(
                  icon: const Icon(Icons.queue_music, color: LupinTheme.neonPink, size: 22),
                  onPressed: widget.onOpenQueue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
