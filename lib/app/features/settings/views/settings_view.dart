import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/common/constants/constants.dart';
import 'package:timer/l10n/l10n.dart';

import '../widgets/widgets.dart';

class SettingsView extends HookWidget {
  static const routePath = 'settings';
  static const routeName = 'settings';

  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settings)),
      body: ListView(
        padding: kAppPadding.copyWith(top: 20, bottom: 32),
        children: const [
          LanguageSwitcher(),
          SizedBox(height: 20),
          ThemeSwitcher(),
        ],
      ),
    );
  }
}
