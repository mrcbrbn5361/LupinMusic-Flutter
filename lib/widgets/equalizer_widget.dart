import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../theme/lupin_theme.dart';

class EqualizerWidget extends StatelessWidget {
  const EqualizerWidget({Key? key}) : super(key: key);

  final List<String> _frequencies = const ['60Hz', '230Hz', '910Hz', '4kHz', '14kHz'];

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerProvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: LupinTheme.glassDecoration(radius: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.tune, color: LupinTheme.neonPink),
                  SizedBox(width: 8),
                  Text(
                    'Audio Equalizer',
                    style: TextStyle(
                      color: LupinTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  for (int i = 0; i < 5; i++) {
                    player.setEqBand(i, 0.0);
                  }
                },
                child: const Text('Reset', style: TextStyle(color: LupinTheme.neonPurple)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final val = player.eqBands[index];
              return Column(
                children: [
                  Text(
                    '${val.toStringAsFixed(1)} dB',
                    style: const TextStyle(color: LupinTheme.textSecondary, fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          activeTrackColor: LupinTheme.neonPink,
                          inactiveTrackColor: LupinTheme.surfaceLight,
                          thumbColor: LupinTheme.neonPurple,
                          overlayColor: LupinTheme.neonPink.withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                        ),
                        child: Slider(
                          value: val,
                          min: -10.0,
                          max: 10.0,
                          onChanged: (nVal) {
                            player.setEqBand(index, nVal);
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _frequencies[index],
                    style: const TextStyle(
                      color: LupinTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
