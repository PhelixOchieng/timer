import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/features/settings/repository/vibrations_repository.dart';
import 'package:vibration/vibration.dart';

import 'package:timer/app/core/players/audio_player.dart';
import 'package:timer/app/features/settings/models/sound_model.dart';
import 'package:timer/app/features/settings/repository/sounds_repository.dart';
import 'package:timer/l10n/l10n.dart';
import 'package:timer/app/features/views.dart';

import '../widgets/widgets.dart';

class HomeView extends HookConsumerWidget {
  static const routePath = '/';
  static const routeName = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersState = ref.watch(audioPlayerProvider);
    final soundsState = ref.watch(soundsProvider);
    final vibrationsState = ref.watch(vibrationsProvider);

    final playerS = useState<AudioPlayer?>(null);
    final player = playerS.value;
    void initPlayer() async {
      debugPrint('Init Player');
      // if (player != null) playersState.releasePlayer(player.playerId);

      final source = _getSource(soundsState.alarmSound);
      playerS.value = await playersState.createPlayer(
        'alarm-done',
        source: source,
        loop: true,
        // mode: PlayerMode.mediaPlayer,
      );
    }

    useEffect(() {
      debugPrint('Home Init');
      initPlayer();

      return;
    }, []);

    void setPlayerSource() {
      final source = _getSource(soundsState.alarmSound);
      player?.setSource(source);
    }

    useEffect(() {
      debugPrint('Alarm change: $player');
      setPlayerSource();

      return;
    }, [soundsState.alarmSound]);

    final isPlayingAudio = useState(false);

    final vibrationTimer = useRef<Timer?>(null);
    void playAudio() async {
      debugPrint('Play: $player');
      vibrationTimer.value?.cancel();
      setPlayerSource();

      await player?.stop();
      await player?.resume();
      debugPrint('PS: ${player?.state}');
      isPlayingAudio.value = true;

      if (!vibrationsState.areVibrationsEnabled) return;

      final vibration = vibrationsState.alarmVibration;
      vibration.vibrate();
      vibrationTimer.value = Timer.periodic(
        const Duration(seconds: 2),
        (_) {
          vibration.vibrate();
          // Vibration.vibrate(pattern: [0, 100, 150, 100, 75, 100, 470]);
        },
      );
    }

    void stopAudio() async {
      await player?.stop();
      vibrationTimer.value?.cancel();
      Vibration.cancel();

      isPlayingAudio.value = false;
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => context.pushNamed(SettingsView.routeName),
              icon: const Icon(Icons.api_rounded))
        ],
      ),
      body: Column(
        children: [
          // Text('${player?.playerId} ${player?.releaseMode}'),
          Expanded(child: Center(child: Dial(onPlay: playAudio))),
          // ElevatedButton(
          //     onPressed: () async {
          //       debugPrint('Called');
          //       // await HapticFeedback.heavyImpact();
          //       // await HapticFeedback.lightImpact();
          //       // await HapticFeedback.mediumImpact();
          //       // await HapticFeedback.selectionClick();
          //       // await HapticFeedback.vibrate();
          //       // debugPrint('${await Vibration.hasVibrator()}');
          //       playAudio();
          //     },
          //     child: Text('Buzz')),
          if (isPlayingAudio.value) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                    onPressed: stopAudio,
                    icon: Icon(
                      Icons.stop_rounded,
                      size: 36,
                      color: theme.colorScheme.secondary,
                    ),
                    label: Text(context.l10n.stop)),
              ],
            ),
            const SizedBox(height: 20),
          ]
        ],
      ),
    );
  }

  Source _getSource(SoundModel sound) {
    final source =
        sound.isAsset ? AssetSource(sound.path) : DeviceFileSource(sound.path);
    return source;
  }
}
