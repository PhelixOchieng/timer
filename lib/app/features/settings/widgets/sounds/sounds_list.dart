import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/core/players/audio_player.dart';
import 'package:timer/app/features/settings/models/sounds_model.dart';
import 'package:timer/app/features/settings/repository/sounds_repository.dart';

import 'enums.dart';

class SoundsList extends HookConsumerWidget {
  const SoundsList({super.key, required this.selection});

  final SoundSelection selection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsState = ref.watch(soundsProvider);
    final playersState = ref.watch(audioPlayerProvider);
    final sounds = soundsState.sounds;

    final selectedSound = useState<SoundModel>(selection == SoundSelection.alarm
        ? soundsState.alarmSound
        : soundsState.detentsSound);
    final initialSelectedSound = useState(selectedSound.value);

    // //! FIXME: Find a better fix for the audio not playing sometimes
    final playerS = useState<AudioPlayer?>(null);
    final player = playerS.value;
    void initPlayer() async {
      debugPrint('Init');

      playerS.value = await playersState.createPlayer('audio-sampler',
          mode: PlayerMode.mediaPlayer);
    }

    useEffect(() {
      debugPrint('Rund');
      initPlayer();
      return;
    }, []);

    void selectSound(SoundModel? sound) async {
      debugPrint('Play audio: $player $sound');
      if (player == null) return;

      final s = sound ?? selectedSound.value;
      final Source playerSource =
          s.isAsset ? AssetSource(s.path) : DeviceFileSource(s.path);
      // await player.stop();
      await player.play(playerSource);

      debugPrint('Sound: $sound ${selectedSound.value}');
      if (sound == null) return;
      selectedSound.value = sound;

      return;
    }

    Future<void> saveSoundSelection() async {
      final sound = selectedSound.value;

      if (selection == SoundSelection.alarm) {
        await soundsState.saveAlarmSound(sound);
      } else {
        await soundsState.saveDetentsSound(sound);
      }
    }

    void handleSaveClick() {
      debugPrint('Called');
      saveSoundSelection().then((_) => Navigator.of(context).pop());
    }

    useEffect(() {
      debugPrint('Initial');

      return () {
        debugPrint('Release');
        if (player != null) playersState.releasePlayer(player.playerId);
      };
    }, []);

    debugPrint('build: $player');

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Sound'),
        actions: [
          IconButton(
            onPressed: initialSelectedSound.value != selectedSound.value
                ? handleSaveClick
                : null,
            icon: const Icon(Icons.check_rounded),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: sounds.length,
          itemBuilder: (_, idx) {
            final sound = sounds[idx];
            return RadioListTile<SoundModel>(
              value: sound,
              groupValue: selectedSound.value,
              onChanged: selectSound,
              title: Text(sound.name),
              toggleable: true,
              subtitle: Text(sound.path, overflow: TextOverflow.ellipsis),
            );
          }),
    );
  }
}
