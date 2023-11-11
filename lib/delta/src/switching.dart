import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

/// Switch control
///
class Switching extends StatelessWidget {
  const Switching({
    super.key,
    required this.controller,
  });

  final ValueNotifier<bool>? controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<ValueNotifier<bool>?>(builder: (context, _, __) {
          return CupertinoSwitch(
              value: controller == null ? false : controller!.value,
              onChanged: controller == null
                  ? null
                  : (value) {
                      controller!.value = value;
                    });
        }));
  }
}
