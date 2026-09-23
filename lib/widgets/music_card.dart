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
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: active ? LupinTheme.bgCardHover : LupinTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? LupinTheme.accentPink : LupinTheme.borderSubtle,
              width: 1.2,
            ),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: LupinTheme.accentPinkGlow,
                      blurRadius: 20,
                      offset: Offset(0, 6),
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1:1 Aspect Ratio Square with YouTube black bars cropped out via 1.34x scale
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Container(
                        color: const Color(0xFF17072A),
                        width: double.infinity,
                        height: double.infinity,
                        child: Transform.scale(
                          scale: 1.34, // Crops away 45px black letterboxing bars
                          child: Image.network(
                            widget.track.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const Center(
                              child: Icon(Icons.music_note, color: LupinTheme.accentPink, size: 36),
                            ),
                          ),
                        ),
                      ),

                      // Hover/Playing Neon Play Button Overlay
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 180),
                        right: 8,
                        bottom: active ? 8 : -40,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 180),
                          opacity: active ? 1.0 : 0.0,
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LupinTheme.neonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: LupinTheme.accentPinkGlow,
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: Icon(
                              widget.isPlaying ? Icons.equalizer : Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Title
              Text(
                widget.track.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: LupinTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),

              const SizedBox(height: 3),

              // Artist
              Text(
                widget.track.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: LupinTheme.textSecondary,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
