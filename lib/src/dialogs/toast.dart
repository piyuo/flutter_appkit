import 'package:flutter/cupertino.dart';

const double _TOAST_WIDTH = 240;

const double _TOAST_HEIGHT = 160;

class Toast extends StatelessWidget {
  final String message;

  final Color foregroundColor;

  final Color backgroundColor;

  final IconData? icon;

  Toast({
    required this.message,
    this.foregroundColor = CupertinoColors.white,
    this.backgroundColor = CupertinoColors.darkBackgroundGray,
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
              decoration: BoxDecoration(color: backgroundColor),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Wrap(
                    children: [
                      icon != null
                          ? SizedBox(
                              width: _TOAST_WIDTH,
                              child: Icon(
                                icon,
                                size: 38,
                                color: foregroundColor,
                              ))
                          : SizedBox(),
                      SizedBox(
                          width: _TOAST_WIDTH,
                          child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                      SizedBox(height: 20),
                    ],
                  )))),
    );
  }
}
