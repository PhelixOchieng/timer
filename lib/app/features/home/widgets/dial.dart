import 'dart:async';
import 'dart:math';

import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';

class Dial extends HookWidget {
  const Dial({super.key});

  @override
  Widget build(BuildContext context) {
    final pressedAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.96,
    );
    final pressedAnimation = useAnimation(pressedAnimationController);

    final timeSelection = useState<TimeSelection?>(TimeSelection.seconds);
    final isSelectingSeconds = timeSelection.value == TimeSelection.seconds;
    final isSelectingMinutes = timeSelection.value == TimeSelection.minutes;
    final isSelectingHours = timeSelection.value == TimeSelection.hours;

    final selectedSeconds = useState(0);
    final selectedMinutes = useState(0);
    final selectedHours = useState(0);
    final countdownSeconds = useRef(0);
    final isSelecting =
        isSelectingSeconds || isSelectingMinutes || isSelectingHours;

    final dialRotationAngle = useState(0.0);
    final timer = useRef<Timer?>(null);
    final isTimerRunning = timer.value != null;
    void stopTimer() {
      debugPrint('Stop timer: ${countdownSeconds.value}');
      timer.value?.cancel();
      timer.value = null;

      timeSelection.value = TimeSelection.seconds;
      countdownSeconds.value = 0;
      dialRotationAngle.value = 0;
      selectedSeconds.value = selectedMinutes.value = selectedHours.value = 0;
    }

    void startCountdown() {
      timer.value?.cancel();
      debugPrint('Start clock');
      countdownSeconds.value = (selectedHours.value * 60 * 60) +
          (selectedMinutes.value * 60) +
          selectedSeconds.value;
      timer.value = Timer.periodic(const Duration(seconds: 1), (_) {
        countdownSeconds.value -= 1;
        final remainingSeconds = countdownSeconds.value;

        selectedHours.value =
            ((remainingSeconds % (60 * 60 * 24)) / (60 * 60)).floor();
        selectedMinutes.value = ((remainingSeconds % (60 * 60)) / 60).floor();
        selectedSeconds.value = ((remainingSeconds % 60)).floor();

        if (remainingSeconds <= 0) stopTimer();
      });
    }

    useEffect(() {
      switch (timeSelection.value) {
        case TimeSelection.seconds:
          dialRotationAngle.value = (selectedSeconds.value / 60) * (2 * pi);
          break;
        case TimeSelection.minutes:
          dialRotationAngle.value = (selectedMinutes.value / 60) * (2 * pi);
          break;
        case TimeSelection.hours:
          dialRotationAngle.value = (selectedHours.value / 24) * (2 * pi);
          break;
        case null:
      }

      debugPrint('${dialRotationAngle.value} - ${timeSelection.value}');

      return;
    }, [timeSelection.value]);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final availableWidth =
        MediaQuery.of(context).size.width - kAppPadding.horizontal;
    final dialSize = availableWidth * 0.75;
    const detentMargin = 10.0;
    final paddedDialSize = dialSize - (detentMargin * 2);
    const detentSize = 24.0;

    return GestureDetector(
      onTapDown: (_) => pressedAnimationController.reverse(),
      onTapUp: (_) => pressedAnimationController.forward(),
      onTapCancel: pressedAnimationController.forward,
      onTap: () {
        if (isSelectingSeconds) {
          timeSelection.value = TimeSelection.minutes;
        } else if (isSelectingMinutes) {
          timeSelection.value = TimeSelection.hours;
        } else if (isSelectingHours) {
          timeSelection.value = null;
        } else {
          startCountdown();
        }
      },
      onPanUpdate: (details) {
        final pos = details.localPosition;

        final zeroX = dialSize / 2;
        final zeroY = dialSize / 2;
        final resolvedX = pos.dx - zeroX;
        final resolvedY = -(pos.dy - zeroY);

        double angle = atan(resolvedX / resolvedY);

        if (resolvedX >= 0 && resolvedY < 0) {
          angle = (pi / 2) + ((pi / 2) - angle.abs());
        } else if (resolvedX < 0 && resolvedY < 0) {
          angle += pi;
        } else if (resolvedX <= 0 && resolvedY > 0) {
          angle = pi + ((pi / 2) + ((pi / 2) - angle.abs()));
        }

        if (angle == 2 * pi) angle = 0;

        // debugPrint('$angle ${angle * (180 / pi)} ${angleDeg % 6}');
        dialRotationAngle.value = angle;

        final angleDeg = (angle * (180 / pi)).floor();
        if (isSelectingSeconds) {
          selectedSeconds.value = (angleDeg * (60 / 360)).floor();
        } else if (isSelectingMinutes) {
          selectedMinutes.value = (angleDeg * (60 / 360)).floor();
        } else if (isSelectingHours) {
          selectedHours.value = (angleDeg * (24 / 360)).floor();
        }
      },
      onPanEnd: (_) {
        double angle = dialRotationAngle.value;
        final angleDeg = (angle * (180 / pi)).floor();

        double angleChange = 0;
        if (isSelectingSeconds || isSelectingMinutes) {
          angleChange = 360 / 60;
        } else if (isSelectingHours) {
          angleChange = 360 / 24;
        }

        if (angleDeg % angleChange == 0) return;

        angle -= (angleDeg % angleChange) * ((2 * pi) / 360);
        dialRotationAngle.value = angle;
      },
      child: Transform.scale(
        scale: pressedAnimation,
        child: Stack(
          children: [
            Container(
              width: dialSize,
              height: dialSize,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    ..._topLeftShadows(theme),
                    ..._bottomRightShadows(theme),
                  ]),
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: isSelecting
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultTextStyle(
                                  style: textTheme.headline1!.copyWith(),
                                  child: isSelectingSeconds
                                      ? Text('${selectedSeconds.value}')
                                      : isSelectingMinutes
                                          ? Text('${selectedMinutes.value}')
                                          : Text('${selectedHours.value}')),
                              const SizedBox(height: 12),
                              Text(
                                  'Select ${isSelectingSeconds ? 'Seconds' : isSelectingMinutes ? 'Minutes' : 'Hours'}'),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              if (!isTimerRunning) const SizedBox(height: 32),
                              FittedBox(
                                child: DefaultTextStyle(
                                  style: textTheme.headline1!,
                                  child: Row(
                                    children: [
                                      Text(_parseTime(selectedHours.value)),
                                      const Text(':'),
                                      Text(_parseTime(selectedMinutes.value)),
                                      const Text(':'),
                                      Text(_parseTime(selectedSeconds.value)),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isTimerRunning) ...[
                                const SizedBox(height: 12),
                                const Text('Tap To Start',
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {},
                                  child: TextButton.icon(
                                    onPressed: stopTimer,
                                    icon: const Icon(Icons.restart_alt),
                                    label: Text('Reset',
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              ],
                              if (isTimerRunning)
                                TextButton.icon(
                                    onPressed: stopTimer,
                                    icon: const Icon(Icons.stop_rounded),
                                    label: Text('Stop Timer'))
                            ],
                          )),
              ),
            ),
            if (isSelecting)
              Positioned(
                left: (dialSize / 2) - (detentSize / 2),
                top: detentMargin,
                height: paddedDialSize,
                // width: detentSize,
                child: Transform.rotate(
                  angle: dialRotationAngle.value,
                  child: Column(
                    children: [
                      Container(
                        width: detentSize,
                        height: detentSize,
                        decoration: BoxDecoration(
                            // color: theme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.65)),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.1),
                                offset: const Offset(0, -1),
                              ),
                              // BoxShadow(
                              //   color: theme.colorScheme.secondary
                              //       .withOpacity(0.6),
                              //   offset: const Offset(0, 0),
                              //   blurRadius: 6,
                              // ),
                              BoxShadow(
                                color: theme.colorScheme.secondary,
                                spreadRadius: -5,
                                blurRadius: 5,
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  String _parseTime(int time) {
    return time < 10 ? '0$time' : '$time';
  }

  List<BoxShadow> _topLeftShadows(ThemeData theme) {
    final color = theme.isLightMode
        ? Colors.white
        : theme.colorScheme.primary.darken(0.34);

    return [
      BoxShadow(
        color: color,
        offset: const Offset(-3, -3),
      ),
      BoxShadow(
          color: color.withOpacity(0.8),
          offset: const Offset(-6, -6),
          blurRadius: 4),
      BoxShadow(
          color: color.withOpacity(0.6),
          offset: const Offset(-12, -12),
          blurRadius: 8),
    ];
  }

  List<BoxShadow> _bottomRightShadows(ThemeData theme) {
    final color = theme.isLightMode
        ? theme.colorScheme.primary.withOpacity(0.1)
        : theme.colorScheme.primary.darken(0.3).withOpacity(0.1);
    return [
      BoxShadow(
          color: color.darken(0.05), offset: const Offset(3, 3), blurRadius: 2),
      BoxShadow(
          color: color.darken(0.05), offset: const Offset(6, 6), blurRadius: 4),
      BoxShadow(
          color: color.darken(0.3),
          offset: const Offset(12, 12),
          blurRadius: 8),
    ];
  }
}

enum TimeSelection {
  seconds,
  minutes,
  hours;
}
