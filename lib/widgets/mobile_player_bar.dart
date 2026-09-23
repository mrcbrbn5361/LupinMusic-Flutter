import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/lupin_theme.dart';
import 'animated_equalizer.dart';

class MobilePlayerBar extends StatelessWidget {
  final VoidCallback onOpenQueue;

  const MobilePlayerBar({Key? key, required this.onOpenQueue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final track = player.currentTrack;

    if (track == null) return const SizedBox.shrink();

    final position = player.position;
    final duration = player.duration;
    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xF2160728),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: LupinTheme.borderGlow, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 16,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Album Art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Transform.scale(
                      scale: 1.34,
                      child: Image.network(
                        track.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.music_note, color: LupinTheme.accentPink),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        track.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LupinTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        track.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: LupinTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Equalizer
                AnimatedEqualizerBars(isPlaying: player.isPlaying),
                const SizedBox(width: 8),

                // Play / Pause
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LupinTheme.neonGradient,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: player.isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            player.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 20,
                          ),
                    onPressed: player.togglePlayPause,
                  ),
                ),
                const SizedBox(width: 4),

                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next, color: LupinTheme.textSecondary, size: 22),
                  onPressed: player.nextTrack,
                ),
              ],
            ),
          ),

          // Mini neon progress bar on bottom edge
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: const AlwaysStoppedAnimation<Color>(LupinTheme.accentPink),
              minHeight: 2.5,
            ),
          ),
        ],
      ),
    );
  }
}
