import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'value_notifier_provider.dart';

/// Switch control
///
class Switch extends StatelessWidget {
  const Switch({
    Key? key,
    required this.controller,
    this.disabled,
  }) : super(key: key);

  final ValueNotifier<bool> controller;

  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifierProvider>(
        create: (context) => ValueNotifierProvider(controller),
        child: Consumer<ValueNotifierProvider>(builder: (context, model, child) {
          return CupertinoSwitch(
              value: model.valueNotifier.value,
              onChanged: disabled == true
                  ? null
                  : (value) {
                      model.valueNotifier.value = value;
                    });
        }));
  }
}
