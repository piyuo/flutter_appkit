import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:libcli/eventbus.dart';

class AwaitErrorMessage extends StatelessWidget {
  final backgroundColor = Color.fromRGBO(203, 29, 57, 1);

  final void Function() onRetryPressed;

  AwaitErrorMessage({
    required this.onRetryPressed,
  });

  content(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Icon(
          Icons.warning_outlined,
          color: Colors.white,
          size: 120,
        ),
        SizedBox(height: 10),
        AutoSizeText(
          'errTitle'.i18n_,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        SizedBox(height: 10),
        AutoSizeText(
          'notified'.i18n_,
          maxLines: 5,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 40),
        InkWell(
            onTap: () => broadcast(context, EmailSupportEvent()),
            child: Icon(
              Icons.mail_outline,
              color: Colors.orange[200],
              size: 38,
            )),
        SizedBox(width: 10),
        InkWell(
            onTap: () => broadcast(context, EmailSupportEvent()),
            child: Text(
              'emailUs'.i18n_,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.orange[200],
                fontSize: 14.0,
              ),
            )),
        SizedBox(height: 60),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            color: Colors.white,
            child: Text('retry'.i18n_, style: TextStyle(color: Colors.redAccent)),
            onPressed: onRetryPressed,
          ),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
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
