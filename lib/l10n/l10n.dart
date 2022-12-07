// ignore_for_file: file_names
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension TranslationX on BuildContext {
  String translateIfExists(String text) {
    String translated = text;

    if (text == 'English') {
      translated = l10n.english;
    } else if (text == 'Swahili') {
      translated = l10n.swahili;
    } else if (text == 'Portuguese') {
      translated = l10n.portuguese;
    } else if (text == 'French') {
      translated = l10n.french;
    } else if (text == 'Spanish') {
      translated = l10n.spanish;
    } else if (text == 'Arabic') {
      translated = l10n.arabic;
    }

    return translated;
  }
}
