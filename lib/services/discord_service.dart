import 'dart:io';
import 'package:discord_rpc/discord_rpc.dart';
import '../models/track.dart';

class DiscordService {
  DiscordRPC? _rpc;

  void init() {
    if (!Platform.isWindows && !Platform.isMacOS && !Platform.isLinux) return;
    try {
      DiscordRPC.initialize();
      _rpc = DiscordRPC(applicationId: '120000000000000000'); // Lupin App ID
      _rpc?.start();
    } catch (_) {}
  }

  void updatePresence(Track track, Duration currentPosition) {
    if (_rpc == null) return;
    try {
      _rpc?.updatePresence(
        DiscordPresence(
          details: track.title,
          state: 'by ${track.artist}',
          largeImageKey: 'lupin_logo',
          largeImageText: 'Lupin Music Stream',
          smallImageKey: 'playing_icon',
          smallImageText: 'Playing',
        ),
      );
    } catch (_) {}
  }

  void clearPresence() {
    _rpc?.clearPresence();
  }

  void dispose() {
    _rpc?.shutDown();
  }
}
