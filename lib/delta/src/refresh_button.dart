import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:provider/provider.dart';
import 'indicator.dart';

/// RefreshButtonController control refresh button show refreshing animation
class RefreshButtonController extends ValueNotifier<bool> {
  /// RefreshButtonController control refresh button show refreshing animation
  RefreshButtonController() : super(false);
}

/// RefreshButton show icon button with refreshing animation
/// ```dart
/// Consumer<RefreshButtonController>(
///     builder: (context, provide, child) => Column(children: [
///        RefreshButton(
///            onPressed: () async {
///              await Future.delayed(const Duration(seconds: 5));
///            }),
///        ]))
/// ```
class RefreshButton extends StatelessWidget {
  /// RefreshButton show icon button with refreshing animation
  /// ```dart
  /// Consumer<RefreshButtonController>(
  ///     builder: (context, provide, child) => Column(children: [
  ///        RefreshButton(
  ///            onPressed: () async {
  ///              await Future.delayed(const Duration(seconds: 5));
  ///            }),
  ///        ]))
  /// ```
  const RefreshButton({
    required this.onPressed,
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  /// onRefresh call when user press button
  final Future<void> Function()? onPressed;

  /// size is icon size
  final double size;

  /// color is icon color
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshButtonController>(
        builder: (context, controller, _) => IconButton(
              iconSize: size,
              color: color,
              icon: controller.value
                  ? SizedBox(width: size + 16, height: size + 16, child: ballRotateChase())
                  : const Icon(
                      Icons.refresh,
                    ),
              onPressed: onPressed != null
                  ? () async {
                      controller.value = true;
                      try {
                        await onPressed!();
                      } finally {
                        controller.value = false;
                      }
                    }
                  : null,
              tooltip: context.i18n.refreshButtonText,
            ));
  }
}
