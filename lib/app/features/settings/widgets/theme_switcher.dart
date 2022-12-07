import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';
import 'package:timer/app/core/theme/app_theme.dart';
import 'package:timer/l10n/l10n.dart';

class ThemeSwitcher extends HookConsumerWidget {
  const ThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final currentTheme = themeState.themeMode;

    final initialThemeMode = useRef(currentTheme);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final inactiveChipColor = theme.isLightMode
        ? Colors.black.withOpacity(0.05)
        : Colors.white.withOpacity(0.1);
    final activeColor = theme.isLightMode ? null : kTextColorLight;

    final options = [
      {
        'mode': ThemeMode.light,
        'icon': Icons.light_mode_rounded,
        'label': context.l10n.light
      },
      {
        'mode': ThemeMode.dark,
        'icon': Icons.dark_mode_rounded,
        'label': context.l10n.dark
      },
      {
        'mode': ThemeMode.system,
        'icon': Icons.devices_rounded,
        'label': context.l10n.automatic
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.theme, style: textTheme.titleLarge),
            TextButton(
                onPressed: initialThemeMode.value != currentTheme
                    ? () {
                        themeState.saveThemeMode(currentTheme);
                        initialThemeMode.value = currentTheme;
                      }
                    : null,
                child: Text(context.l10n.save)),
          ],
        ),
        Wrap(
          spacing: 20,
          children: options.map((opt) {
            final themeMode = opt['mode'] as ThemeMode;
            final isActive = currentTheme == themeMode;
            final icon = opt['icon'] as IconData;
            final label = opt['label'] as String;

            return InkWell(
              onTap: () => themeState.setThemeMode(themeMode),
              splashColor: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isActive
                      ? theme.colorScheme.primaryContainer
                      : inactiveChipColor,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                          opacity: 0.7,
                          child: Icon(icon,
                              size: 32, color: isActive ? activeColor : null)),
                      const SizedBox(height: 8),
                      Text(label,
                          textAlign: TextAlign.center,
                          style: isActive
                              ? textTheme.bodyMedium
                                  ?.copyWith(color: activeColor)
                              : null),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
