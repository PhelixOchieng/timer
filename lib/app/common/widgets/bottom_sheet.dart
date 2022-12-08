import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../utils/extensions.dart';

class _BottomSheetWrapper extends StatelessWidget {
  const _BottomSheetWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = MediaQuery.of(context);
    final bottomPadding = query.viewInsets.bottom + 12.0;

    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: kAppPadding.left,
              vertical: 12.0,
            ).copyWith(bottom: bottomPadding),
            color: theme.surfaceColor,
            child: SafeArea(child: child)));
  }
}

void showCustomModalBottomSheet({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  final theme = Theme.of(context);

  showModalBottomSheet(
      context: context,
      barrierColor: theme.isLightMode
          ? const Color.fromRGBO(161, 161, 161, 0.25)
          : Colors.black.withOpacity(0.25),
      backgroundColor: Colors.transparent,
      builder: (context) => _BottomSheetWrapper(child: builder(context)));
}
