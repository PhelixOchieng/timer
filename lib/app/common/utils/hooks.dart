import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class _FormKey extends Hook<GlobalKey<FormState>> {
  const _FormKey();

  @override
  _FormKeyState createState() => _FormKeyState();
}

class _FormKeyState extends HookState<GlobalKey<FormState>, _FormKey> {
  final key = GlobalKey<FormState>();

  @override
  void initHook() {
    super.initHook();
  }

  @override
  GlobalKey<FormState> build(BuildContext context) => key;
}

GlobalKey<FormState> useFormKey() {
  return use(const _FormKey());
}
