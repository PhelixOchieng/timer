import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:timer/app/features/views.dart';

///
/// for getting routers that are present in the app
///
final routerProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      initialLocation: HomeView.routePath,
      routes: [
        /// TODO: Add onboarding screen
        /// for showing onboarding
        GoRoute(
            path: HomeView.routePath,
            name: HomeView.routeName,
            builder: (context, state) => const HomeView()),
        GoRoute(
            path: SettingsView.routePath,
            name: SettingsView.routeName,
            builder: (_, __) => const SettingsView())
      ],
    );
  },
);
