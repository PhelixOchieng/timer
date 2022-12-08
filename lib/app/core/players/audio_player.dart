import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final Ref _ref;
  AudioPlayerProvider(this._ref);

  Map<String, AudioPlayer> _players = {};
  AudioPlayer createPlayer(String playerID,
      {PlayerMode? mode, bool loop = false}) {
    final potentialPlayer = _players[playerID];
    if (potentialPlayer != null) return potentialPlayer;

    final player = AudioPlayer(playerId: playerID);
    if (mode != null) player.setPlayerMode(mode);
    if (loop) player.setReleaseMode(ReleaseMode.loop);

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
