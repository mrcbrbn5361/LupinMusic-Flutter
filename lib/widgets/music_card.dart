import 'package:flutter/material.dart';
import '../models/track.dart';
import '../theme/lupin_theme.dart';

class MusicCard extends StatefulWidget {
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
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isPlaying || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: active ? LupinTheme.bgCardHover : LupinTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? LupinTheme.accentPink : LupinTheme.borderSubtle,
              width: 1.0,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: widget.isPlaying
                          ? LupinTheme.accentPinkGlow
                          : LupinTheme.accentPurpleGlow,
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1:1 Aspect Ratio Square Album Thumbnail
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color(0xFF17072A),
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.network(
                          widget.track.thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => const Center(
                            child: Icon(Icons.music_note, color: LupinTheme.accentPurple, size: 36),
                          ),
                        ),
                      ),
                    ),

                    // Play Button Overlay on Hover or Playing
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      right: 10,
                      bottom: active ? 10 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: active ? 1.0 : 0.0,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LupinTheme.neonGradient,
                            boxShadow: const [
                              BoxShadow(
                                color: LupinTheme.accentPinkGlow,
                                blurRadius: 14,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Icon(
                            widget.isPlaying ? Icons.equalizer : Icons.play_arrow,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                widget.track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: LupinTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 4),

              // Artist
              Text(
                widget.track.artist,
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
      ),
    );
  }
}
