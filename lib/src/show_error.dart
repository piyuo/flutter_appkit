import 'package:flutter/cupertino.dart';
import 'package:libcli/src/l10n/l10n.dart';

import 'global_context.dart';

Future<void> showError(dynamic e, StackTrace? stack) async {
  // First check: prevent multiple dialogs from being open simultaneously

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
