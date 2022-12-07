import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/core/local_storage/app_storage.dart';

import 'language.model.dart';

class LanguagesRepository extends ChangeNotifier {
  final Ref _ref;
  final AppStorage _storage;

  late LanguageModel _appLanguage;
  LanguagesRepository(this._ref) : _storage = _ref.read(appStorageProvider) {
    _appLanguage = languages.first;

    final appLanguage = _storage.getAppLanguage();
    if (appLanguage != null) {
      _appLanguage = appLanguage;
      _setAppLocaleFromLanguage(_appLanguage);
      return;
    }

    _usePlatformLocale();
  }

  void _usePlatformLocale() {
    final platformLocaleSplit = Platform.localeName.split('_');
    final platformLocale =
        Locale(platformLocaleSplit[0], platformLocaleSplit[1]);
    _setAppLanguageFromLocale(platformLocale);
  }

  Locale? _appLocale;
  void _setAppLocaleFromLanguage(LanguageModel language) {
    final code = language.code.split('_');
    final languageSubtag = code[0];

    Locale locale = Locale(languageSubtag);
    if (code.length == 2) locale = Locale(languageSubtag, code[1]);

    _appLocale = locale;
    notifyListeners();
  }

  void setAppLanguage(LanguageModel language) {
    _appLanguage = language;
    _setAppLocaleFromLanguage(language);
    notifyListeners();
  }

  void saveAppLanguage([LanguageModel? language]) {
    _appLanguage = language ?? _appLanguage;
    _setAppLocaleFromLanguage(_appLanguage);
    _storage.putAppLanguage(_appLanguage);

    notifyListeners();
  }

  void _setAppLanguageFromLocale(Locale locale) {
    final language = languages
        .firstWhereOrNull((language) => locale.languageCode == language.code);

    if (language == null) return;

    _appLanguage = language;
    _appLocale = locale;
    notifyListeners();
  }

  void reset() {
    _usePlatformLocale();
    notifyListeners();
  }

  Locale? get appLocale => _appLocale;
  LanguageModel get appLanguage => _appLanguage;

  final languages = const <LanguageModel>[
    LanguageModel(name: 'English', code: 'en', icon: 'GB.svg'),
    LanguageModel(name: 'Swahili', code: 'sw', icon: 'TZ.svg'),
    LanguageModel(name: 'French', code: 'fr', icon: 'FR.svg'),
    LanguageModel(name: 'Portuguese', code: 'pt', icon: 'PT.svg'),
    LanguageModel(name: 'Russian', code: 'ru', icon: 'RU.svg'),
    LanguageModel(name: 'Arabic', code: 'ar', icon: 'SA.svg'),
    LanguageModel(name: 'Spanish', code: 'es', icon: 'ES.svg'),
  ];
}

final languagesProvider = ChangeNotifierProvider<LanguagesRepository>((ref) {
  return LanguagesRepository(ref);
});
