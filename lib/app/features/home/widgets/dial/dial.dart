import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:color_fns/color_fns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';
import 'package:timer/app/common/widgets/widgets.dart';
import 'package:timer/app/core/players/audio_player.dart';
import 'package:timer/l10n/l10n.dart';

import 'input_sheet.dart';
import 'enums.dart';

class Dial extends HookConsumerWidget {
  const Dial({super.key, required this.onPlay});

  final void Function() onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(audioPlayerProvider);

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
    void setRotationAngle(double angle) async {
      dialRotationAngle.value = angle;
    }

    const detentVolume = 0.5;
    final playerFuture = useFuture(playerState.createPlayer(
      'detent',
      source: AssetSource('sounds/click_1.mp3'),
      volume: detentVolume,
    ));
    final player = playerFuture.data;
    Future<void> playDetent() async {
      if (player == null) return;

      await player.stop();
      await player.resume();
    }

    final detentPlayTimer = useRef<Timer?>(null);
    void fn() async {
      detentPlayTimer.value?.cancel();

      detentPlayTimer.value =
          Timer.periodic(const Duration(milliseconds: 800), (timer) async {
        await player!.setVolume(0);
        await playDetent();
      });
    }

    useEffect(() {
      if (player == null || timeSelection.value == null) {
        detentPlayTimer.value?.cancel();
        return;
      }

      // TODO: Find a better way to reduce play latency
      // fn();
      return;
    }, [timeSelection.value, player]);

    final timer = useRef<Timer?>(null);
    final isTimerRunning = timer.value != null;
    void stopTimer({bool playSound = false}) {
      debugPrint('Stop timer: ${countdownSeconds.value}');
      timer.value?.cancel();
      timer.value = null;

      timeSelection.value = TimeSelection.seconds;
      countdownSeconds.value = 0;
      dialRotationAngle.value = 0;
      selectedSeconds.value = selectedMinutes.value = selectedHours.value = 0;

      if (playSound) onPlay();
    }

    final playPauseAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );
    final isTimerPaused = useRef(false);
    void startCountdown() {
      if (!isTimerPaused.value && isTimerRunning) return;

      debugPrint('Start clock');
      timer.value?.cancel();

      isTimerPaused.value = false;
      playPauseAnimationController.reverse();

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

        if (remainingSeconds <= 0) stopTimer(playSound: true);
      });
    }

    useEffect(() {
      //? Maybe avoid this check to play the detent when the countdown continues
      if (!isTimerPaused.value && isTimerRunning) return;
      player?.setVolume(detentVolume).then((_) => playDetent());
      return;
    }, [selectedSeconds.value, selectedMinutes.value, selectedHours.value]);

    final gotoTimeViewAfterSelection = useRef(false);
    void gotoNext() {
      if (gotoTimeViewAfterSelection.value) {
        timeSelection.value = null;
        gotoTimeViewAfterSelection.value = false;
        return;
      }

      if (isSelectingSeconds) {
        timeSelection.value = TimeSelection.minutes;
      } else if (isSelectingMinutes) {
        timeSelection.value = TimeSelection.hours;
      } else if (isSelectingHours) {
        if (selectedSeconds.value == 0 &&
            selectedMinutes.value == 0 &&
            selectedHours.value == 0) {
          timeSelection.value = TimeSelection.seconds;
        } else {
          timeSelection.value = null;
        }
      } else {
        startCountdown();
      }
    }

    void goBack() {
      if (gotoTimeViewAfterSelection.value) {
        timeSelection.value = null;
        gotoTimeViewAfterSelection.value = false;
        return;
      }

      if (isSelectingMinutes) {
        timeSelection.value = TimeSelection.seconds;
      } else if (isSelectingHours) {
        timeSelection.value = TimeSelection.minutes;
      }
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

      return;
    }, [timeSelection.value]);

    void resumeTimer() {
      startCountdown();
    }

    void pauseTimer() {
      playPauseAnimationController.forward();
      timer.value?.cancel();
      isTimerPaused.value = true;
    }

    void toggleTimerState() {
      if (isTimerPaused.value) {
        resumeTimer();
      } else {
        pauseTimer();
      }
    }

    useEffect(() {
      return () {
        detentPlayTimer.value?.cancel();
      };
    }, []);

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
      onTap: gotoNext,
      // TODO: Only run the detent loop when the user is not panning
      onPanDown: (_) {},
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
        setRotationAngle(angle);

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
        final angle =
            _shouldUpdateAngle(dialRotationAngle.value, isSelectingHours);
        if (angle == null) return;

        dialRotationAngle.value = angle;
      },
      onLongPress: () {
        pressedAnimationController.forward();
        if (!isSelecting) return;

        showCustomModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => InputSheet(
                  timeSelection: timeSelection,
                  selectedSeconds: selectedSeconds,
                  selectedMinutes: selectedMinutes,
                  selectedHours: selectedHours,
                ));
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
                              isSelectingSeconds
                                  ? const SizedBox(height: 8)
                                  : const SizedBox(height: 20),
                              DefaultTextStyle(
                                  style: textTheme.headline1!.copyWith(),
                                  child: isSelectingSeconds
                                      ? Text(_parseTime(selectedSeconds.value))
                                      : isSelectingMinutes
                                          ? Text(
                                              _parseTime(selectedMinutes.value))
                                          : Text(
                                              _parseTime(selectedHours.value))),
                              // const SizedBox(height: 12),
                              Text(isSelectingSeconds
                                  ? context.l10n.selectSeconds
                                  : isSelectingMinutes
                                      ? context.l10n.selectMinutes
                                      : context.l10n.selectHours),
                              // const SizedBox(height: 4),
                              // Text(context.l10n.pressToContinue,
                              //     style: textTheme.caption),
                              if (!isSelectingSeconds)
                                IconButton(
                                    onPressed: goBack,
                                    icon: const Icon(
                                        Icons.keyboard_backspace_rounded),
                                    color: theme.colorScheme.primary)
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
                                      GestureDetector(
                                        onLongPress: !isTimerRunning ||
                                                isTimerPaused.value
                                            ? () {
                                                gotoTimeViewAfterSelection
                                                    .value = true;
                                                timeSelection.value =
                                                    TimeSelection.hours;
                                              }
                                            : null,
                                        child: Text(
                                            _parseTime(selectedHours.value)),
                                      ),
                                      const Text(':'),
                                      GestureDetector(
                                        onLongPress: !isTimerRunning ||
                                                isTimerPaused.value
                                            ? () {
                                                gotoTimeViewAfterSelection
                                                    .value = true;
                                                timeSelection.value =
                                                    TimeSelection.minutes;
                                              }
                                            : null,
                                        child: Text(
                                            _parseTime(selectedMinutes.value)),
                                      ),
                                      const Text(':'),
                                      GestureDetector(
                                        onLongPress: !isTimerRunning ||
                                                isTimerPaused.value
                                            ? () {
                                                gotoTimeViewAfterSelection
                                                    .value = true;
                                                timeSelection.value =
                                                    TimeSelection.seconds;
                                              }
                                            : null,
                                        child: Text(
                                            _parseTime(selectedSeconds.value)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (!isTimerRunning) ...[
                                const SizedBox(height: 12),
                                Text(context.l10n.tapToStart,
                                    textAlign: TextAlign.center),
                                InkWell(
                                  onTap: () {},
                                  child: TextButton.icon(
                                    onPressed: stopTimer,
                                    icon: const Icon(Icons.restart_alt),
                                    label: Text(context.l10n.reset,
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              ],
                              if (isTimerRunning)
                                IconTheme(
                                  data: theme.iconTheme.copyWith(
                                    size: 28,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: toggleTimerState,
                                        icon: AnimatedIcon(
                                          icon: AnimatedIcons.pause_play,
                                          progress:
                                              playPauseAnimationController,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: stopTimer,
                                          icon: const Icon(Icons.stop_rounded))
                                    ],
                                  ),
                                ),
                            ],
                          )),
              ),
            ),
            // Text('${player?.playerId} ${player?.releaseMode}'),
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

  double? _shouldUpdateAngle(double angle, bool isSelectingHours) {
    final angleDeg = (angle * (180 / pi)).floor();

    double angleChange = 0;
    if (isSelectingHours) {
      angleChange = 360 / 24;
    } else {
      angleChange = 360 / 60;
    }

    if (angleDeg % angleChange == 0) return null;

    angle -= (angleDeg % angleChange) * ((2 * pi) / 360);
    return angle;
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
    // final color = theme.isLightMode
    //     ? theme.colorScheme.primary.darken(0.05)
    //     : theme.colorScheme.primary.darken(0.3).withOpacity(0.1);
    final color = theme.colorScheme.primary;

    return [
      BoxShadow(
          color: theme.isLightMode
              ? color.darken(0.05).withOpacity(0.1)
              : color.darken(0.34),
          offset: const Offset(3, 3),
          blurRadius: 2),
      BoxShadow(
          color: theme.isLightMode
              ? color.darken(0.05).withOpacity(0.1)
              : color.darken(0.34),
          offset: const Offset(6, 6),
          blurRadius: 4),
      BoxShadow(
          color: theme.isLightMode
              ? color.darken(0.3).withOpacity(0.1)
              : color.darken(0.34),
          offset: const Offset(12, 12),
          blurRadius: 8),
    ];
  }
}
