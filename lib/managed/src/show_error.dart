import 'package:flutter/cupertino.dart';
import 'package:libcli/l10n/l10n.dart';

import 'global_context_support.dart';

void showError(dynamic e, StackTrace? stack) {
  showCupertinoDialog(
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
      content: Text(context.l.managed_error_content),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(context.l.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
