import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/app/common/utils/extensions.dart';
import 'package:timer/app/core/language/language_repository.dart';
import 'package:timer/app/core/theme/app_theme.dart';
import 'package:timer/l10n/l10n.dart';

class LanguageSwitcher extends HookConsumerWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languagesState = ref.watch(languagesProvider);
    final currentLanguage = languagesState.appLanguage;

    final initialLanguage = useRef(currentLanguage);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final inactiveChipColor = theme.isLightMode
        ? Colors.black.withOpacity(0.05)
        : Colors.white.withOpacity(0.1);
    final activeColor = theme.isLightMode ? null : kTextColorLight;

    const spacing = 16.0;
    const runSpacing = 16.0;
    const itemHeight = 100.0;
    const itemExtent = 3;

    final availableWidth =
        MediaQuery.of(context).size.width - kAppPadding.horizontal;
    final itemWidth =
        (availableWidth - ((itemExtent - 1) * spacing)) / itemExtent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.language, style: textTheme.titleLarge),
            TextButton(
                onPressed: initialLanguage.value != currentLanguage
                    ? () {
                        // languagesState.saveThemeMode(currentTheme);
                        initialLanguage.value = currentLanguage;
                      }
                    : null,
                child: Text(context.l10n.save)),
          ],
        ),
        Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: languagesState.languages.map((lang) {
            final isActive = currentLanguage == lang;

            return InkWell(
              onTap: () => languagesState.setAppLanguage(lang),
              splashColor: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                width: itemWidth,
                height: itemHeight,
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
                          child: SvgPicture.asset(
                            'assets/icons/countries/${lang.icon}',
                            width: itemWidth * 0.5,
                          )),
                      const SizedBox(height: 8),
                      Text(context.translateIfExists(lang.name),
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
        )
      ],
    );
  }
}
