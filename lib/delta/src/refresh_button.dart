import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'indicator.dart';
import 'extensions.dart';

/// RefreshButton show animation when refreshing
class RefreshButton extends StatefulWidget {
  const RefreshButton({
    required this.onRefresh,
    Key? key,
    this.iconSize = 24,
  }) : super(key: key);

  /// onRefresh call when user press button
  final Future<void> Function(BuildContext context) onRefresh;

  /// iconSize is status light icon size
  final double iconSize;

  @override
  State<StatefulWidget> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize,
      icon: _isRefreshing
          ? CircularProgressIndicator(
              strokeWidth: 5,
              color: context.themeColor(light: Colors.grey[700]!, dark: Colors.grey[200]!),
            )
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
      tooltip: 'refresh'.i18n_,
    );
  }
}
