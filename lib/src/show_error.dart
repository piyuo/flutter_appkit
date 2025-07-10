import 'package:flutter/cupertino.dart';
import 'package:libcli/l10n/l10n.dart';

import 'global_context.dart';

Future<void> showError(dynamic e, StackTrace? stack) async {
  await showCupertinoDialog(
    context: globalContext,
    builder: (context) => CupertinoAlertDialog(
      title: Row(children: [
        Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: CupertinoColors.destructiveRed,
          size: 48.0,
        ),
        Expanded(child: Text(context.l.managed_error_oops)),
      ]),
      content: Column(children: [
        Text(context.l.managed_error_content),
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
