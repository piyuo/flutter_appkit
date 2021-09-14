import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'popup.dart';
import 'listing.dart';
import 'device.dart';

const ITEM_HEIGHT = 40.0;

double _menuHeight(int itemCount) {
  var menuHeight = itemCount * ITEM_HEIGHT;
  final screenHeight = screenSize().height;
  if (menuHeight > screenHeight * 2 / 3) {
    menuHeight = screenHeight * 2 / 3;
  }
  return menuHeight + 20;
}

/// menu will popup menu and return value when user selected
///
///
Future<T?> menu<T>(
  BuildContext context, {
  required List<ListingItem> items,
  GlobalKey? target,
  double targetPadding = 3,
  double? left,
  double? top,
  double? width,
  double? height,
}) {
  final completer = Completer<T?>();
  if (target != null) {
    final rect = getWidgetGlobalRect(target);
    left = rect.left;
    width = rect.width;
    height = _menuHeight(items.length);
    top = rect.top - height;
    if (top <= MediaQuery.of(context).padding.top + targetPadding) {
      // The have not enough space above, show menu under the widget.
      top = rect.height + rect.top + targetPadding;
    } else {
      top = top - targetPadding - 3; // 5 for shadow
    }
  }
  if (left == null || top == null || width == null || height == null) {
    completer.complete(null);
    return completer.future;
  }

  final listingController = ValueNotifier<T?>(null);
  Popup? pop;
  pop = popup(
    context,
    rect: Rect.fromLTWH(left, top, width, height),
    child: SizedBox(
      width: width,
      height: height,
      child: Material(
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Listing<T>(
            controller: listingController,
            dense: true,
            padding: EdgeInsets.zero,
            items: items,
            onItemTap: (context, T key) {
              completer.complete(key);
              pop!.dismiss();
            },
          ),
        ),
      ),
    ),
    onDismiss: () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    },
  );
  return completer.future;
}
