import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String message;
  final Function okPressed;
  final String okText;
  final Function closePressed;
  final String closeText;
  final Function linkPressed;
  final IconData linkIcon;
  final String linkText;

  MessageDialog({
    this.color,
    this.icon,
    this.title,
    this.message,
    this.okPressed,
    this.okText,
    this.closePressed,
    this.closeText,
    this.linkPressed,
    this.linkIcon,
    this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 320, maxHeight: 360),
      child: Container(
        color: color,
        width: 320,
        height: 360,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Icon(
              icon,
              color: Colors.white,
              size: 80,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 1, 10, 10),
                child: SelectableText(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                )),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: messageDialogContent(),
                    ),
                    messageDialogLink(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        messageDialogButton(context, closeText ?? '',
                            Colors.white, Colors.grey[700], 0, 1, closePressed),
                        SizedBox(width: 10),
                        messageDialogButton(context, okText ?? '', color,
                            Colors.white, 4, 8, okPressed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageDialogButton(
    BuildContext context,
    String text,
    Color background,
    Color color,
    double elevation,
    double hoverElevation,
    Function onPressed,
  ) {
    return Visibility(
        visible: text.isNotEmpty,
        child: SizedBox(
          width: 145.0,
          child: RaisedButton(
            elevation: elevation,
            hoverElevation: hoverElevation,
            onPressed: () {
              onPressed();
              Navigator.of(context).pop();
            },
            child: Text(
              text,
              style: TextStyle(color: color),
            ),
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(110),
              //side: BorderSide(color: border),
            ),
          ),
        ));
  }

  Widget messageDialogContent() {
    return SingleChildScrollView(
        child: SelectableText(message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            )));
  }

  Widget messageDialogLink() {
    return Visibility(
        visible: linkPressed != null,
        child: Material(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: linkPressed,
                      child: Icon(
                        linkIcon,
                        color: color,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                        onTap: linkPressed,
                        child: Text(
                          linkText ?? '',
                          style: TextStyle(fontSize: 12, color: color),
                        )),
                  ],
                ))));
  }
}
