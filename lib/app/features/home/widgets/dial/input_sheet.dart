import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timer/app/common/utils/hooks.dart';
import 'package:timer/l10n/l10n.dart';

import 'enums.dart';

class InputSheet extends HookWidget {
  const InputSheet({
    super.key,
    required this.timeSelection,
    required this.selectedSeconds,
    required this.selectedMinutes,
    required this.selectedHours,
  });

  final ValueNotifier<TimeSelection?> timeSelection;
  final ValueNotifier<int> selectedSeconds;
  final ValueNotifier<int> selectedMinutes;
  final ValueNotifier<int> selectedHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final formKey = useFormKey();

    final isSelectingSeconds = timeSelection.value == TimeSelection.seconds;
    final isSelectingMinutes = timeSelection.value == TimeSelection.minutes;
    final isSelectingHours = timeSelection.value == TimeSelection.hours;

    final numController = useTextEditingController(
        text: isSelectingSeconds
            ? '${selectedSeconds.value}'
            : isSelectingMinutes
                ? '${selectedMinutes.value}'
                : '${selectedHours.value}');
    void setValue() async {
      if (!formKey.currentState!.validate()) return;

      Navigator.of(context).pop();

      final number = int.parse(numController.text);
      TimeSelection? selection;
      if (isSelectingSeconds) {
        selectedSeconds.value = number;
        selection = TimeSelection.minutes;
      } else if (isSelectingMinutes) {
        selectedMinutes.value = number;
        selection = TimeSelection.hours;
      } else {
        selectedHours.value = number;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      timeSelection.value = selection;
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              isSelectingSeconds
                  ? context.l10n.selectSeconds
                  : isSelectingMinutes
                      ? context.l10n.selectMinutes
                      : context.l10n.selectHours,
              style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: numController,
            autofocus: true,
            autocorrect: false,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => setValue(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.l10n.fieldRequired;
              }

              if (!RegExp(r'^\d+$').hasMatch(value)) {
                return context.l10n.notNumber;
              }

              final number = int.parse(value);
              if (isSelectingHours && (number < 0 || number > 23)) {
                return context.l10n.numberRangeInvalid(0, 24);
              }
              if (number < 0 || number > 59) {
                return context.l10n.numberRangeInvalid(0, 60);
              }

              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(context.l10n.cancel)),
              const SizedBox(width: 8),
              ElevatedButton(
                  onPressed: setValue, child: Text(context.l10n.save)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
