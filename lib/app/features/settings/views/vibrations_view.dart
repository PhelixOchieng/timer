import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/l10n/l10n.dart';

import '../models/vibration_model.dart';
import '../repository/vibrations_repository.dart';

class VibrationsView extends HookConsumerWidget {
  const VibrationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vibrationsState = ref.watch(vibrationsProvider);
    final areVibrationsEnabled = vibrationsState.areVibrationsEnabled;
    final vibrations = vibrationsState.vibrations;

    final selectedVibration = useState(vibrationsState.alarmVibration);
    final initialVibration = useState(selectedVibration.value);

    void toggleVibrationsEnabled(bool enable) {
      if (enable) {
        vibrationsState.enableVibrations();
      } else {
        vibrationsState.disableVibrations();
      }
    }

    final vibrationTimer = useState<Timer?>(null);
    final isVibrating = vibrationTimer.value != null;
    final isMounted = useIsMounted();
    void stopVibration() async {
      vibrationTimer.value?.cancel();
      await selectedVibration.value.stop();

      if (isMounted()) vibrationTimer.value = null;
    }

    void playVibration(VibrationModel vibration) async {
      await vibration.vibrate();
      vibrationTimer.value =
          Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (timer.tick >= 2) {
          stopVibration();
        } else {
          vibration.vibrate();
        }
      });
    }

    void selectVibration(VibrationModel? vibration) async {
      playVibration(vibration ?? selectedVibration.value);

      if (vibration == null) return;
      selectedVibration.value = vibration;
    }

    void saveSelectedVibration() async {
      stopVibration();
      await vibrationsState.saveAlarmVibration(selectedVibration.value);
      initialVibration.value = selectedVibration.value;
    }

    void resetSettings() async {
      stopVibration();
      await vibrationsState.reset();

      final vibration = vibrationsState.alarmVibration;

      debugPrint('Vibration change: $vibration');
      selectedVibration.value = vibration;
      initialVibration.value = vibration;

      return;
    }

    final canEnableVibrations =
        useMemoized(vibrationsState.canEnableVibrations);

    useEffect(() {
      return stopVibration;
    }, []);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.vibrations),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: canEnableVibrations,
              builder: (context, AsyncSnapshot<bool> data) {
                final canEnable = data.data;

                return SwitchListTile.adaptive(
                  value: areVibrationsEnabled,
                  onChanged: canEnable == true ? toggleVibrationsEnabled : null,
                  title: Text(context.l10n.enableVibrations),
                );
              }),
          const Divider(),
          Opacity(
            opacity: areVibrationsEnabled ? 1 : 0.5,
            child: Padding(
              padding: kAppPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.l10n.chooseVibration,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      )),
                  Row(
                    children: [
                      if (isVibrating) ...[
                        IconButton(
                          onPressed: stopVibration,
                          icon: Icon(Icons.stop_rounded,
                              color: theme.colorScheme.primary),
                        ),
                        // const SizedBox(width: 4),
                      ],
                      IconButton(
                        onPressed:
                            initialVibration.value != selectedVibration.value
                                ? saveSelectedVibration
                                : null,
                        icon: const Icon(Icons.check_rounded),
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vibrations.length,
              itemBuilder: (_, idx) {
                final vibration = vibrations[idx];

                return RadioListTile<VibrationModel>(
                  value: vibration,
                  groupValue: selectedVibration.value,
                  onChanged: areVibrationsEnabled ? selectVibration : null,
                  title: Text(vibration.name),
                  toggleable: true,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
              onPressed: resetSettings,
              icon: AnimatedCrossFade(
                crossFadeState: vibrationsState.isResetting
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                firstChild: const Icon(Icons.settings_backup_restore_rounded),
                secondChild: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: SizedBox(
                      width: 16,
                      height: 16,
                      child:
                          CircularProgressIndicator.adaptive(strokeWidth: 2)),
                ),
              ),
              label: Text(context.l10n.reset)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
