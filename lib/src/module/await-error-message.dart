import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AwaitErrorMessage extends StatelessWidget {
  final backgroundColor = Color.fromRGBO(203, 29, 57, 1);

  final void Function() onEmailLinkPressed;

  final void Function() onRetryPressed;

  AwaitErrorMessage({
    required this.onEmailLinkPressed,
    required this.onRetryPressed,
  });

  content(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Icon(
          CupertinoIcons.exclamationmark_shield,
          color: CupertinoColors.white,
          size: 120,
        ),
        SizedBox(height: 10),
        AutoSizeText(
          'errTitle'.i18n_,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 10),
        AutoSizeText(
          'errMsg'.i18n_,
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: CupertinoColors.systemRed,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 40),
        GestureDetector(
            onTap: onEmailLinkPressed,
            child: Icon(
              CupertinoIcons.envelope,
              color: CupertinoColors.activeBlue,
              size: 38,
            )),
        GestureDetector(
            onTap: onEmailLinkPressed,
            child: Text(
              'emailAdr'.i18n_,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CupertinoColors.activeBlue,
                fontSize: 14.0,
              ),
            )),
        SizedBox(height: 60),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: CupertinoButton(
            padding: EdgeInsets.all(0.0),
            color: CupertinoColors.activeBlue,
            child: Text('retry'.i18n_, style: TextStyle(color: CupertinoColors.activeBlue)),
            onPressed: onRetryPressed,
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      child: SafeArea(
          right: false,
          bottom: false,
          child: SingleChildScrollView(
              child: Center(
            child: Container(
                padding: EdgeInsets.all(40),
                child:
                    ConstrainedBox(constraints: BoxConstraints(minWidth: 300, maxWidth: 360), child: content(context))),
          ))),
    );
  }
}
