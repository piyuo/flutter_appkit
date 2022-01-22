import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// RefreshButtonProvider can control refresh button is busy
class RefreshButtonProvider with ChangeNotifier {
  /// _busy is true if in refresh or load more
  bool _busy = false;

  void setBusy(bool busy) {
    if (_busy != busy) {
      _busy = busy;
      notifyListeners();
    }
  }
}

/// RefreshButton show animation when refreshing
class RefreshButton extends StatelessWidget {
  const RefreshButton({
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

  @override
  Widget build(BuildContext context) {
    return Consumer<RefreshButtonProvider>(
        builder: (context, provide, c) => IconButton(
              iconSize: size,
              color: color,
              icon: provide._busy
                  ? SizedBox(
                      width: size - 8,
                      height: size - 8,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: color,
                      ))
                  : const Icon(
                      Icons.refresh,
                    ),
              onPressed: () async {
                provide.setBusy(true);
                try {
                  await onPressed();
                } finally {
                  provide.setBusy(false);
                }
              },
              tooltip: context.i18n.refreshButtonText,
            ));
  }
}
