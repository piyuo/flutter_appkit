import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/toast.dart';
import 'package:libcli/src/dialogs/popup.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';
import 'package:libcli/eventbus.dart';

/// dialogsNavigatorKey used in rootContext
///
final dialogsNavigatorKey = new GlobalKey<NavigatorState>();

/// dialogsRootContext return context from navigatorKey
///
BuildContext get dialogsRootContext {
  assert(dialogsNavigatorKey.currentState != null && dialogsNavigatorKey.currentState!.overlay != null,
      'you need set navigatorKey: dialogsNavigatorKey in CupertinoApp');
  return dialogsNavigatorKey.currentState!.overlay!.context;
}

/// DialogOverlay provide overlay for dialog
///
class DialogOverlay extends StatelessWidget {
  final Widget child;

  DialogOverlay({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OKToast(child: child);
  }
}

/// alert show alert dialog
///
Future<void> alert(
  BuildContext context,
  String message, {
  String? title,
  Icon? icon,
  String? description,
  bool emailUs = false,
}) async {
  return showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                icon ?? SizedBox(),
                SizedBox(height: 10),
                Text(message, style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 20),
                description != null
                    ? Text(description, style: TextStyle(fontSize: 13.0, color: CupertinoColors.systemGrey))
                    : SizedBox(),
                emailUs == true ? _emailUs(() => broadcast(context, EmailSupportEvent())) : SizedBox(),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('close'.i18n_),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      });
}

/// confirm show confirm dialog, return true if press ok
///
Future<bool> confirm(
  BuildContext context,
  String message, {
  String? title,
  Icon? icon,
  String? labelOK,
  String? labelCancel,
  String? description,
  bool emailUs = false,
}) async {
  var result = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                icon ?? SizedBox(),
                SizedBox(height: 10),
                Text(message, style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 20),
                description != null
                    ? Text(description, style: TextStyle(fontSize: 13.0, color: CupertinoColors.systemGrey))
                    : SizedBox(),
                emailUs == true ? _emailUs(() => broadcast(context, EmailSupportEvent())) : SizedBox(),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(labelCancel ?? 'cancel'.i18n_),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(labelOK ?? 'ok'.i18n_),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      });
  if (result == true) {
    return true;
  }
  return false;
}

Widget _emailUs(void Function()? onPressed) {
  return Container(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: onPressed,
        child: Icon(
          CupertinoIcons.envelope,
          color: CupertinoColors.activeBlue,
          size: 18,
        ),
      ),
      Expanded(
          child: GestureDetector(
              onTap: onPressed,
              child: Text(
                'emailUs'.i18n_,
                style: TextStyle(fontSize: 14, color: CupertinoColors.activeBlue),
              ))),
    ],
  ));
}

/// toast show toast
///
Function toast(
  BuildContext context,
  String message, {
  Icon? icon,
}) {
  ToastFuture future = showToastWidget(
    Toast(
      icon: icon,
      message: message,
      backgroundColor: CupertinoColors.darkBackgroundGray,
    ),
    context: context,
    dismissOtherToast: true,
    duration: Duration(seconds: 0),
  );

  return () {
    future.timer.cancel();
    future.dismiss();
  };
}

/// popMenu show menu
///
Future<MenuItem> popMenu(
  BuildContext context, {
  required List<MenuItem> items,
  required GlobalKey widgetKey,
}) {
  Completer<MenuItem> completer = new Completer<MenuItem>();
  PopupMenu(
    context: context,
    items: items,
    onClickItem: (item) {
      completer.complete(item);
    },
  )..show(widgetKey: widgetKey);
  return completer.future;
}

/// tooltip show tooltip
///
void tooltip(
  BuildContext context,
  String message, {
  double width = 160,
  double height = 40,
  backgroundColor: CupertinoColors.darkBackgroundGray,
  GlobalKey? widgetKey,
  Rect? widgetRect,
}) {
  var popup = Popup(
    context: context,
    child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        child: Text(message, style: TextStyle(fontSize: 14, color: CupertinoColors.white))),
    itemWidth: width,
    itemHeight: height,
    backgroundColor: backgroundColor,
  );

  popup.show(widgetKey: widgetKey, rect: widgetRect);
}
