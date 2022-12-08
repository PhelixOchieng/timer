import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/players/audio_player.dart';
import 'package:timer/app/features/views.dart';

import '../widgets/widgets.dart';

class HomeView extends HookConsumerWidget {
  static const routePath = '/';
  static const routeName = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersState = ref.watch(audioPlayerProvider);
    final player = playersState.createPlayer('alarm-done',
        mode: PlayerMode.lowLatency, loop: true);

    final isPlayingAudio = useState(false);

    final vibrationTimer = useRef<Timer?>(null);
    void playAudio() async {
      vibrationTimer.value?.cancel();
      await player.play(AssetSource('sounds/bell_2.mp3'));
      isPlayingAudio.value = true;

      vibrationTimer.value =
          Timer.periodic(const Duration(seconds: 4), (timer) {
        HapticFeedback.lightImpact();
      });
    }

    void stopAudio() async {
      await player.stop();
      vibrationTimer.value?.cancel();

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
          Expanded(child: Center(child: Dial(onPlay: playAudio))),
          // ElevatedButton(
          //     onPressed: () async {
          //       debugPrint('Called');
          //       // await HapticFeedback.heavyImpact();
          //       // await HapticFeedback.lightImpact();
          //       // await HapticFeedback.mediumImpact();
          //       // await HapticFeedback.selectionClick();
          //       await HapticFeedback.vibrate();
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
                    label: Text('Stop')),
              ],
            ),
            const SizedBox(height: 20),
          ]
        ],
      ),
    );
  }
}
