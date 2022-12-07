import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timer/app/features/views.dart';

import '../widgets/widgets.dart';

class HomeView extends ConsumerWidget {
  static const routePath = '/';
  static const routeName = 'home';

  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => context.pushNamed(SettingsView.routeName),
              icon: const Icon(Icons.api_rounded))
        ],
      ),
      body: const Center(child: Dial()),
    );
  }
}
