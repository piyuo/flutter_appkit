import 'dart:async';
import 'package:flutter/material.dart';

/// slide show slide window
///
Future<void> slide(BuildContext context, Widget widget) {
  return showGeneralDialog(
    barrierLabel: "slide",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 220),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 300,
          child: SizedBox.expand(child: widget),
//          margin: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: child,
      );
    },
  );
}
