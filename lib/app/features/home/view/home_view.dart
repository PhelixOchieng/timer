import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/common/constants/constants.dart';

import 'package:timer/app/common/utils/extensions.dart';

class HomeView extends ConsumerWidget {
  static const routePath = '/';
  static const routeName = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableWidth =
        MediaQuery.of(context).size.width - kAppPadding.horizontal;
    final dialSize = availableWidth * 0.5;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
        width: dialSize,
        height: dialSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      )),
    );
  }
}
