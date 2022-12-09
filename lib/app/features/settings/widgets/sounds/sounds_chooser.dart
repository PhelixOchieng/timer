import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';
import 'package:timer/l10n/l10n.dart';

import '../../repository/sounds_repository.dart';
import '../../repository/vibrations_repository.dart';
import '../../views/sounds_list_view.dart';
import '../../views/vibrations_view.dart';
import 'enums.dart';

class SoundsChooser extends HookConsumerWidget {
  const SoundsChooser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundsState = ref.watch(soundsProvider);
    final selectedAlarmSound = soundsState.alarmSound;
    final selectedDetentsSound = soundsState.detentsSound;

    final vibrationsState = ref.watch(vibrationsProvider);
    final selectedVibration = vibrationsState.alarmVibration;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    void gotoChoices(SoundSelection selection) {
      context.swipeTo(SoundsListView(selection: selection));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: kAppPadding,
          child: Text(context.l10n.sounds, style: textTheme.titleLarge),
        ),
        ListTile(
          onTap: () => gotoChoices(SoundSelection.alarm),
          title: Text(context.l10n.alarm),
          subtitle:
              Text(selectedAlarmSound.name, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        ),
        const Divider(height: 0),
        ListTile(
          onTap: () => gotoChoices(SoundSelection.detents),
          title: Text(context.l10n.detents),
          subtitle:
              Text(selectedDetentsSound.name, overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        ),
        const Divider(height: 0),
        ListTile(
          onTap: () => context.swipeTo(const VibrationsView()),
          title: Text(context.l10n.vibrations),
          subtitle: Text(
              vibrationsState.areVibrationsEnabled
                  ? selectedVibration.name
                  : context.l10n.disabled,
              overflow: TextOverflow.ellipsis),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        ),
      ],
    );
  }
}
