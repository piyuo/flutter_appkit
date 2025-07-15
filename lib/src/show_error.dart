// ===============================================
// show_error.dart
//
// Provides a Cupertino-style error dialog with an option
// for users to report errors anonymously.
//
// Sections:
//   - Imports
//   - showError() function: Entry point to show the dialog
//   - _ErrorDialog widget: Stateful dialog UI
// ===============================================

import 'package:flutter/cupertino.dart';

import 'global_context.dart';
import 'l10n/l10n.dart';

/// Displays a Cupertino error dialog with details and an anonymous report option.
///
/// [e] is the error to display.
/// [stack] is the optional stack trace.
///
/// Returns a [Future<bool>] indicating whether the user chose to report anonymously.
Future<bool> showError(dynamic e, StackTrace? stack) async {
  final result = await showCupertinoDialog<bool>(
    context: globalContext,
    routeSettings: const RouteSettings(name: 'error_dialog'),
    builder: (context) => _ErrorDialog(error: e),
  );
  return result ?? false;
}

/// A stateful widget that shows an error dialog with an anonymous reporting checkbox.
class _ErrorDialog extends StatefulWidget {
  final dynamic error;

  /// Creates an error dialog.
  const _ErrorDialog({required this.error});

  @override
  State<_ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<_ErrorDialog> {
  // Tracks whether the user wants to report the error anonymously.
  bool _reportAnonymously = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: CupertinoColors.destructiveRed,
          size: 48.0,
        ),
        // Error title text
        Expanded(child: Text(context.l.error_oops)),
      ]),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // General error message
          Text(context.l.error_content),
          SizedBox(height: 10),
          // Error details
          Text(widget.error.toString(), style: const TextStyle(color: CupertinoColors.systemGrey)),
          SizedBox(height: 10),
          // Anonymous report checkbox and label
          Row(children: [
            CupertinoCheckbox(
              value: _reportAnonymously,
              onChanged: (bool? value) {
                setState(() {
                  _reportAnonymously = value ?? false;
                });
              },
              activeColor: CupertinoColors.destructiveRed,
            ),
            Expanded(
              child:
                  Text(context.l.error_report_anonymously, style: const TextStyle(color: CupertinoColors.systemGrey)),
            ),
          ]),
        ],
      ),
      actions: [
        // Close button
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(context.l.close),
          onPressed: () => Navigator.of(context).pop(_reportAnonymously),
        ),
      ],
    );
  }
}
