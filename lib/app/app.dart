import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/language/language_repository.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';

import '../l10n/l10n.dart';

class App extends ConsumerWidget {
  /// [App]
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    final appTheme = ref.watch(appThemeProvider);
    final languagesState = ref.watch(languagesProvider);

    debugPrint(
        'App Locale: ${languagesState.appLocale} ${languagesState.appLanguage}');

    return MaterialApp.router(
      title: 'Timer',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: appTheme.lightTheme,
      darkTheme: appTheme.darkTheme,
      themeMode: appTheme.themeMode,
      locale: languagesState.appLocale,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
