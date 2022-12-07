import 'dart:async';

import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:timer/app/common/constants/constants.dart';

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

    final selectedSeconds = useState(12);
    final selectedMinutes = useState(0);
    final selectedHours = useState(0);
    final countdownSeconds = useRef(0);
    final isSelecting =
        isSelectingSeconds || isSelectingMinutes || isSelectingHours;

    final timer = useRef<Timer?>(null);
    final isTimerRunning = timer.value != null;
    void stopTimer() {
      debugPrint('Stop timer: ${countdownSeconds.value}');
      timer.value?.cancel();
      timer.value = null;

      timeSelection.value = TimeSelection.seconds;
      countdownSeconds.value = 0;
      selectedSeconds.value = selectedMinutes.value = selectedHours.value = 0;
    }

    void startCountdown() {
      timer.value?.cancel();
      debugPrint('Start clock');
      countdownSeconds.value = (selectedHours.value * 60 * 60) +
          (selectedMinutes.value * 60) +
          selectedSeconds.value;
      timer.value = Timer.periodic(const Duration(seconds: 1), (_) {
        debugPrint('Count: ${countdownSeconds.value}');
        countdownSeconds.value -= 1;
        final remainingSeconds = countdownSeconds.value;

        selectedHours.value =
            ((remainingSeconds % (60 * 60 * 24)) / (60 * 60)).floor();
        selectedMinutes.value = ((remainingSeconds % (60 * 60)) / 60).floor();
        selectedSeconds.value = ((remainingSeconds % 60)).floor();

        if (remainingSeconds <= 0) stopTimer();
      });
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final availableWidth =
        MediaQuery.of(context).size.width - kAppPadding.horizontal;
    final dialSize = availableWidth * 0.75;

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
      child: Transform.scale(
        scale: pressedAnimation,
        child: Container(
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
                          const SizedBox(height: 12),
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
                          if (!isTimerRunning) const SizedBox(height: 12),
                          !isTimerRunning
                              ? const Text(
                                  'Tap To Start',
                                  textAlign: TextAlign.center,
                                )
                              : TextButton.icon(
                                  onPressed: stopTimer,
                                  icon: const Icon(Icons.stop_rounded),
                                  label: Text('Stop Timer'))
                        ],
                      )),
          ),
        ),
      ),
    );
  }

  String _parseTime(int time) {
    return time < 10 ? '0$time' : '$time';
  }

  List<BoxShadow> _topLeftShadows(ThemeData theme) {
    return [
      const BoxShadow(
        color: Colors.white,
        offset: Offset(-3, -3),
      ),
      BoxShadow(
          color: Colors.white.withOpacity(0.8),
          offset: const Offset(-6, -6),
          blurRadius: 4),
      BoxShadow(
          color: Colors.white.withOpacity(0.6),
          offset: const Offset(-12, -12),
          blurRadius: 8),
    ];
  }

  List<BoxShadow> _bottomRightShadows(ThemeData theme) {
    return [
      BoxShadow(
          color: theme.colorScheme.primary.darken(0.05).withOpacity(0.1),
          offset: const Offset(3, 3),
          blurRadius: 2),
      BoxShadow(
          color: theme.colorScheme.primary.darken(0.05).withOpacity(0.1),
          offset: const Offset(6, 6),
          blurRadius: 4),
      BoxShadow(
          color: theme.colorScheme.primary.darken(0.3).withOpacity(0.1),
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
