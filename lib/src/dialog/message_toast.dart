import 'package:flutter/material.dart';

const double _TOAST_WIDTH = 240;

const double _TOAST_HEIGHT = 160;

class MessageToast extends StatelessWidget {
  final String message;

  final Color backgroundColor;

  final IconData icon;

  MessageToast({
    @required this.message,
    this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.0),
      child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _TOAST_WIDTH,
            maxHeight: _TOAST_HEIGHT,
          ),
          child: DecoratedBox(
              decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.black.withOpacity(0.6)),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Wrap(
                    children: [
                      icon != null
                          ? SizedBox(
                              width: _TOAST_WIDTH,
                              child: Icon(
                                icon,
                                size: 60.0,
                                color: Colors.white,
                              ))
                          : SizedBox(),
                      SizedBox(
                          width: _TOAST_WIDTH,
                          child: Text(message,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18))),
                      SizedBox(height: 20),
                    ],
                  )))),
    );
  }
}
