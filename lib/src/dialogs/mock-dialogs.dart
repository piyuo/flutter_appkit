import 'package:flutter/cupertino.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

class MockDialogs extends Dialogs {
  static bool didAlert = false;

  static bool didConfirm = false;

  static bool didError = false;

  static bool didToast = false;

  static bool didPopMenu = false;

  static bool didTooltip = false;

  @override
  Future<void> alert(
    BuildContext context,
    String message, {
    String? title,
    Icon? icon,
    String? description,
  }) async {
    didAlert = true;
  }

  @override
  Future<bool> confirm(
    BuildContext context,
    String message, {
    String? title,
    Icon? icon,
    String? labelOK,
    String? labelCancel,
    String? description,
  }) async {
    didConfirm = true;
    return true;
  }

  @override
  Future<void> error(
    BuildContext context, {
    bool notified = false,
    String? description,
  }) async {
    didError = true;
  }

  @override
  void toast(
    BuildContext context,
    String message, {
    IconData? icon,
  }) {
    didToast = true;
  }

  @override
  Future<MenuItem> popMenu(
    BuildContext context, {
    required List<MenuItem> items,
    required GlobalKey widgetKey,
  }) async {
    didPopMenu = true;
    return items[0];
  }

  @override
  void tooltip(
    BuildContext context,
    String message, {
    double width = 160,
    double height = 40,
    backgroundColor: CupertinoColors.darkBackgroundGray,
    GlobalKey? widgetKey,
    Rect? widgetRect,
  }) {
    didTooltip = true;
  }
}
