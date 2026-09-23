import 'package:flutter/material.dart';
import '../theme/lupin_theme.dart';

class AnimatedEqualizerBars extends StatefulWidget {
  final bool isPlaying;

  const AnimatedEqualizerBars({Key? key, required this.isPlaying}) : super(key: key);

  @override
  State<AnimatedEqualizerBars> createState() => _AnimatedEqualizerBarsState();
}

class _AnimatedEqualizerBarsState extends State<AnimatedEqualizerBars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedEqualizerBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPlaying && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, child) {
        final val = _controller.value;
        final h1 = widget.isPlaying ? (4.0 + 12.0 * val) : 4.0;
        final h2 = widget.isPlaying ? (16.0 - 10.0 * val) : 8.0;
        final h3 = widget.isPlaying ? (6.0 + 10.0 * (1.0 - val)) : 5.0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBar(h1),
            const SizedBox(width: 3),
            _buildBar(h2),
            const SizedBox(width: 3),
            _buildBar(h3),
          ],
        );
      },
    );
  }

  Widget _buildBar(double height) {
    return Container(
      width: 3.5,
      height: height,
      decoration: BoxDecoration(
        color: LupinTheme.accentPink,
        borderRadius: BorderRadius.circular(2),
        boxShadow: const [
          BoxShadow(
            color: LupinTheme.accentPinkGlow,
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }
}
