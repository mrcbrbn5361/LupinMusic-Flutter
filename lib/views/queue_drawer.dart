import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/lupin_theme.dart';

class QueueDrawer extends StatelessWidget {
  const QueueDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);
    final queue = player.queue;

    return Container(
      width: 320,
      color: LupinTheme.background,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: LupinTheme.glassBorder)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.queue_music, color: LupinTheme.neonPink),
                    SizedBox(width: 8),
                    Text(
                      'Play Queue',
                      style: TextStyle(
                        color: LupinTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${queue.length} Tracks',
                  style: const TextStyle(color: LupinTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: queue.isEmpty
                ? const Center(
                    child: Text(
                      'Queue is empty',
                      style: TextStyle(color: LupinTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (ctx, index) {
                      final track = queue[index];
                      final isCurrent = index == player.currentIndex;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCurrent ? LupinTheme.surfaceLight : LupinTheme.surface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: isCurrent
                              ? Border.all(color: LupinTheme.neonPink, width: 1.0)
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              track.thumbnailUrl,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(Icons.music_note, color: LupinTheme.neonPurple, size: 20),
                            ),
                          ),
                          title: Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isCurrent ? LupinTheme.neonPink : LupinTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: LupinTheme.textSecondary, fontSize: 11),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: LupinTheme.textSecondary, size: 16),
                            onPressed: () {
                              player.removeFromQueue(index);
                            },
                          ),
                          onTap: () {
                            player.playTrack(track);
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
