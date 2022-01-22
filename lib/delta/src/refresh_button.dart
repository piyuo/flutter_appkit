import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// RefreshButton show animation when refreshing
class RefreshButton extends StatefulWidget {
  const RefreshButton({
    required this.onRefresh,
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  /// onRefresh call when user press button
  final Future<void> Function(BuildContext context) onRefresh;

  /// size is icon size
  final double size;

  /// color is icon color
  final Color? color;

  @override
  State<StatefulWidget> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.size,
      color: widget.color,
      icon: _isRefreshing
          ? SizedBox(
              width: widget.size - 8,
              height: widget.size - 8,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: widget.color,
              ))
          : const Icon(
              Icons.refresh,
            ),
      onPressed: () async {
        setState(() {
          _isRefreshing = true;
        });
        try {
          await widget.onRefresh(context);
        } finally {
          setState(() {
            _isRefreshing = false;
          });
        }
      },
      tooltip: context.i18n.refreshButtonText,
    );
  }
}
