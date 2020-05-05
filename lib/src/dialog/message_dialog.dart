import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

const double _DIALOG_WIDTH = 320;
const double _DIALOG_HEIGHT = 360;

class MessageDialog extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String message;
  final String notes;
  final Function okOnPressed;
  final String okText;
  final Function closeOnPressed;
  final String closeText;
  final Function linkOnPressed;
  final IconData linkIcon;
  final String linkText;

  MessageDialog({
    this.color,
    this.icon,
    this.title,
    this.message,
    this.notes,
    this.okOnPressed,
    this.okText,
    this.closeOnPressed,
    this.closeText,
    this.linkOnPressed,
    this.linkIcon,
    this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: _DIALOG_WIDTH,
          maxHeight: _DIALOG_HEIGHT,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color),
          child: Wrap(
            children: [
              layoutIcon(),
              layoutTitle(),
              layoutMessage(),
              layoutNotes(),
              layoutLink(),
              layoutButtons(context),
            ],
          ),
        ));
  }

  Widget layoutIcon() {
    return icon != null
        ? SizedBox(
            width: _DIALOG_WIDTH,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 80,
                )),
          )
        : SizedBox(width: _DIALOG_WIDTH, height: 10);
  }

  Widget layoutTitle() {
    return title != null
        ? SizedBox(
            width: _DIALOG_WIDTH,
            child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                child: AutoSizeText(
                  title ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                )),
          )
        : SizedBox(
            width: _DIALOG_WIDTH,
            height: 10,
          );
  }

  Widget layoutMessage() {
    return message != null
        ? SizedBox(
            width: _DIALOG_WIDTH,
            child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: AutoSizeText(
                    message ?? '',
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
          )
        : SizedBox();
  }

  Widget layoutNotes() {
    return notes != null
        ? SizedBox(
            width: _DIALOG_WIDTH,
            child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: Text(
                    notes ?? '',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )),
          )
        : SizedBox();
  }

  Widget layoutLink() {
    return linkOnPressed != null
        ? Material(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: linkOnPressed,
                      child: Icon(
                        linkIcon,
                        color: color,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                        onTap: linkOnPressed,
                        child: Text(
                          linkText ?? '',
                          style: TextStyle(fontSize: 12, color: color),
                        )),
                  ],
                )))
        : SizedBox();
  }

  Widget layoutButtons(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                layoutButton(context, closeText ?? '', Colors.white,
                    Colors.grey[700], 0, 1, closeOnPressed),
                SizedBox(width: 10),
                layoutButton(context, okText ?? '', color, Colors.white, 4, 8,
                    okOnPressed),
              ],
            )));
  }

  Widget layoutButton(
    BuildContext context,
    String text,
    Color background,
    Color color,
    double elevation,
    double hoverElevation,
    Function onPressed,
  ) {
    return onPressed != null
        ? SizedBox(
            width: 145.0,
            child: RaisedButton(
              elevation: elevation,
              hoverElevation: hoverElevation,
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyle(color: color),
              ),
              color: background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(110),
              ),
            ),
          )
        : SizedBox(height: 10);
  }
}
