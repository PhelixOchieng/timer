import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final Ref _ref;
  AudioPlayerProvider(this._ref);

  Map<String, AudioPlayer> _players = {};
  Future<AudioPlayer> createPlayer(
    String playerID, {
    PlayerMode mode = PlayerMode.lowLatency,
    bool loop = false,
    bool release = false,
    double volume = 1,
    Source? source,
  }) async {
    // debugPrint('Players: $_players');
    final potentialPlayer = _players[playerID];
    if (potentialPlayer != null) return potentialPlayer;

    final player = AudioPlayer(playerId: playerID);
    final cache = AudioCache(prefix: 'assets/sounds/');
    player.audioCache = cache;

    if (source != null) await player.setSource(source);
    await player.stop();

    ReleaseMode releaseMode = ReleaseMode.stop;
    if (loop) {
      releaseMode = ReleaseMode.loop;
    } else if (release) {
      releaseMode = ReleaseMode.release;
    }
    await player.setReleaseMode(releaseMode);

    await player.setPlayerMode(mode);
    await player.setVolume(volume);

    _players[playerID] = player;
    return player;
  }

  Future<void> play(String playerID) async {
    AudioPlayer? targetPlayer;

    final futures = <Future<void> Function()>[];
    for (final entry in _players.entries) {
      final id = entry.key;
      final player = entry.value;

      if (id == playerID) {
        targetPlayer = player;
        continue;
      }

      futures.add(player.pause);
    }

    await Future.wait(futures.map((f) => f()));
    targetPlayer?.resume();
  }

  Future<void> releasePlayers() async {
    final futures = <Future<void> Function()>[];
    for (final player in _players.values) {
      futures.add(player.release);
    }

    await Future.wait(futures.map((f) => f()));
    _players.clear();
  }

  Future<void> releasePlayer(String id) async {
    final player = _players[id];
    player?.release();
    _players.remove(id);
  }

  AudioPlayer? getPlayerByID(String id) {
    return _players[id];
  }

  @override
  void dispose() {
    releasePlayers();
    super.dispose();
  }
}

final audioPlayerProvider = ChangeNotifierProvider<AudioPlayerProvider>((ref) {
  return AudioPlayerProvider(ref);
});
