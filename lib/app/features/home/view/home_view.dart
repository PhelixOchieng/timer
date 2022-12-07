import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  static const routePath = '/';
  static const routeName = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Dial()),
    );
  }
}
