import 'package:flutter/cupertino.dart';
import 'package:libcli/src/l10n/l10n.dart';

import 'global_context.dart';

Future<void> showError(dynamic e, StackTrace? stack) async {
  // Hot reload/restart safe approach: check if there's already an error dialog showing
  // by looking for our specific route name in the navigator
  final navigator = Navigator.of(globalContext);

  // Check if there's already an error dialog route active
  bool hasErrorDialog = false;
  navigator.popUntil((route) {
    if (route.settings.name == 'error_dialog' && route.isActive) {
      hasErrorDialog = true;
    }
    return true; // Don't actually pop, just check
  });

  if (hasErrorDialog) {
    return; // Already showing an error dialog, don't show another
  }
  await showCupertinoDialog(
    context: globalContext,
    routeSettings: const RouteSettings(name: 'error_dialog'),
    builder: (context) => CupertinoAlertDialog(
      title: Row(children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: CupertinoColors.destructiveRed,
          size: 48.0,
        ),
        Expanded(child: Text(context.l.error_oops)),
      ]),
      content: Column(children: [
        Text(context.l.error_content),
        SizedBox(height: 10),
        Text(e.toString(), style: const TextStyle(color: CupertinoColors.systemGrey)),
      ]),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: true,
          child: Text(context.l.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
