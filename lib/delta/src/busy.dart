import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'indicator.dart';

/// Busy indicator show busy indicator
class Busy extends StatelessWidget {
  const Busy({
    required this.controller,
    this.indicator,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<bool> controller;

  final Widget? indicator;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<ValueNotifier<bool>>(builder: (context, _, __) {
          return controller.value
              ? indicator ??
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        width: 100,
                        height: 20,
                        child: ballPulseIndicator(),
                      ))
              : const SizedBox();
        }));
  }
}
