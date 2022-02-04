import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'extensions.dart';
import 'indicator.dart';

class RefreshButton extends StatelessWidget {
  /// RefreshButton show animation when refreshing
  const RefreshButton({
    required this.controller,
    required this.onPressed,
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  /// onRefresh call when user press button
  final Future<void> Function() onPressed;

  /// size is icon size
  final double size;

  /// color is icon color
  final Color? color;

  /// controller control refresh button is busy
  final ValueNotifier<bool> controller;

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? context.themeColor(light: Colors.grey.shade600, dark: Colors.grey.shade400);
    return IconButton(
      iconSize: size,
      color: defaultColor,
      icon: controller.value
          ? SizedBox(width: size + 16, height: size + 16, child: ballRotateChase())
          : const Icon(
              Icons.refresh,
            ),
      onPressed: () async {
        controller.value = true;
        try {
          await onPressed();
        } finally {
          controller.value = false;
        }
      },
      tooltip: context.i18n.refreshButtonText,
    );
  }
}
