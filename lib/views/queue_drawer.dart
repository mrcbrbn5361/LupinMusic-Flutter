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
      width: 340,
      decoration: const BoxDecoration(
        color: Color(0xF2120624),
        border: Border(left: BorderSide(color: LupinTheme.borderGlow, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 30,
            offset: Offset(-8, 0),
          )
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    '🎵 Çalma Sırası',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: LupinTheme.accentPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${queue.length}',
                      style: const TextStyle(
                        color: LupinTheme.accentPink,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: LupinTheme.textSecondary, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(color: LupinTheme.borderSubtle, height: 24),

          // Queue List
          Expanded(
            child: queue.isEmpty
                ? const Center(
                    child: Text(
                      'Çalma sırası boş',
                      style: TextStyle(color: LupinTheme.textSecondary, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    itemCount: queue.length,
                    itemBuilder: (ctx, index) {
                      final track = queue[index];
                      final isCurrent = index == player.currentIndex;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0x33A855F7)
                              : Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isCurrent
                                ? LupinTheme.accentPink
                                : Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              track.thumbnailUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.music_note,
                                color: LupinTheme.accentPink,
                              ),
                            ),
                          ),
                          title: Text(
                            track.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isCurrent
                                  ? LupinTheme.accentPink
                                  : Colors.white,
                              fontSize: 13,
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: LupinTheme.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close,
                                color: LupinTheme.textMuted, size: 16),
                            onPressed: () => player.removeFromQueue(index),
                          ),
                          onTap: () => player.playTrack(track),
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
