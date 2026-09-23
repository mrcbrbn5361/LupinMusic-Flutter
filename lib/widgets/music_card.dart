import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/lupin_theme.dart';

class MusicCard extends StatelessWidget {
  final Track track;
  final VoidCallback onTap;
  final bool isPlaying;

  const MusicCard({
    Key? key,
    required this.track,
    required this.onTap,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isPlaying ? LupinTheme.surfaceLight : LupinTheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying ? LupinTheme.neonPink : LupinTheme.glassBorder,
            width: isPlaying ? 1.5 : 1.0,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: LupinTheme.neonPink.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: -2,
                  )
                ]
              : [],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      track.thumbnailUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(
                        color: LupinTheme.surfaceLight,
                        child: const Icon(Icons.music_note, color: LupinTheme.neonPurple, size: 40),
                      ),
                    ),
                  ),
                  if (isPlaying)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.equalizer,
                            color: LupinTheme.neonPink,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 4),
            Text(
              track.artist,
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
    );
  }
}
