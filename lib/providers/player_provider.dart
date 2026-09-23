import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/track.dart';
import '../services/audio_service.dart';
import '../services/youtube_service.dart';
import '../services/discord_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioService _audioService = AudioService();
  final YouTubeService _ytService = YouTubeService();
  final DiscordService _discordService = DiscordService();

  Track? _currentTrack;
  List<Track> _queue = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.8;
  bool _isMuted = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  int _currentPlayId = 0;

  // 5-band Equalizer values (Hz -> dB level -10 to +10)
  final List<double> _eqBands = [0.0, 0.0, 0.0, 0.0, 0.0];

  Track? get currentTrack => _currentTrack;
  List<Track> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _isMuted ? 0.0 : _volume;
  bool get isMuted => _isMuted;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  List<double> get eqBands => List.unmodifiable(_eqBands);

  PlayerProvider() {
    _discordService.init();

    _audioService.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _audioService.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });

    _audioService.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        onTrackEnded();
      } else if (state.processingState == ProcessingState.ready) {
        _isLoading = false;
      }
      notifyListeners();
    });
  }

  Future<void> playTrack(Track track, {List<Track>? newQueue}) async {
    final thisPlayId = ++_currentPlayId;
    _isLoading = true;
    _currentTrack = track;
    notifyListeners();

    if (newQueue != null) {
      _queue = List.from(newQueue);
      _currentIndex = _queue.indexWhere((t) => t.id == track.id);
      if (_currentIndex == -1) {
        _queue.add(track);
        _currentIndex = _queue.length - 1;
      }
    } else if (!_queue.any((t) => t.id == track.id)) {
      _queue.add(track);
      _currentIndex = _queue.length - 1;
    } else {
      _currentIndex = _queue.indexWhere((t) => t.id == track.id);
    }

    try {
      final streamUrl = await _ytService.getAudioStreamUrl(track.id);
      if (thisPlayId != _currentPlayId) return;

      if (streamUrl != null) {
        _currentTrack = track.copyWith(streamUrl: streamUrl);
        await _audioService.playUrl(streamUrl);
        if (thisPlayId != _currentPlayId) return;
        _isLoading = false;
        _isPlaying = true;
        _discordService.updatePresence(_currentTrack!, _position);
      } else {
        _isLoading = false;
      }
    } catch (e) {
      debugPrint('[PlayerProvider] Play error: $e');
      _isLoading = false;
    } finally {
      if (thisPlayId == _currentPlayId) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentTrack == null) return;
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.resume();
    }
  }

  Future<void> seek(Duration pos) async {
    await _audioService.seek(pos);
  }

  Future<void> setVolume(double val) async {
    _volume = val.clamp(0.0, 1.0);
    _isMuted = _volume == 0;
    await _audioService.setVolume(_volume);
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _audioService.setVolume(_isMuted ? 0.0 : _volume);
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  Future<void> nextTrack() async {
    if (_queue.isEmpty) return;
    if (_isShuffle) {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    } else {
      _currentIndex = (_currentIndex + 1) % _queue.length;
    }
    await playTrack(_queue[_currentIndex]);
  }

  Future<void> previousTrack() async {
    if (_queue.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _queue.length) % _queue.length;
    await playTrack(_queue[_currentIndex]);
  }

  void onTrackEnded() {
    if (_isRepeat) {
      seek(Duration.zero);
      _audioService.resume();
    } else {
      nextTrack();
    }
  }

  void setEqBand(int index, double value) {
    if (index >= 0 && index < _eqBands.length) {
      _eqBands[index] = value;
      notifyListeners();
    }
  }

  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      if (_currentIndex >= _queue.length) {
        _currentIndex = _queue.length - 1;
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    _ytService.dispose();
    _discordService.dispose();
    super.dispose();
  }
}
