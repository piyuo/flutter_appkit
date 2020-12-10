import 'package:flutter/cupertino.dart';

const double _TOAST_WIDTH = 280;

const double _TOAST_HEIGHT = 160;

class Toast extends StatelessWidget {
  final String message;

  final Color foregroundColor;

  final Color backgroundColor;

  final Icon? icon;

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
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      icon ?? SizedBox(),
                      Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 16))
                    ],
                  )))),
    );
  }
}
