import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<double> get volumeStream => _player.volumeStream;

  Future<void> playUrl(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(
        url,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
          'Referer': 'https://music.youtube.com/',
        },
      );
      await _player.play();
    } catch (e) {
      debugPrint('[AudioService] Play error: $e');
      rethrow;
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  void dispose() {
    _player.dispose();
  }
}
