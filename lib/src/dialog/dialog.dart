import 'package:flutter/material.dart';
import 'package:piyuo/libcli/dialog/alert_error.dart';
import 'package:piyuo/libcli/dialog/alert_no_internet.dart';
import 'package:piyuo/libcli/dialog/alert_blocked_internet.dart';
import 'package:piyuo/libcli/dialog/alert_disk.dart';
import 'package:piyuo/libcli/dialog/alert_timeout.dart';

show(BuildContext context, {Widget child}) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0)), //this right here
          child: child,
        );
      });
}

alertError(BuildContext context) => show(context, child: AlertError());

alertNoInternet(BuildContext context) =>
    show(context, child: AlertNoInternet());

alertBlockedInternet(BuildContext context) =>
    show(context, child: AlertBlockedInternet());

alertTimeout(BuildContext context) => show(context, child: AlertTimeout());

alertDisk(BuildContext context) => show(context, child: AlertDisk());

infomation(BuildContext context,
    {String title, String message, IconData icon}) {}

warning(BuildContext context, {String title, String message, IconData icon}) {}

alertNetworkTimeout() {}

alertDiskError() {}

/*
alertError(BuildContext context) {
  MessageDialog(
      language: '',
      color: Color.fromRGBO(203, 29, 57, 1),
      icon: Icons.error_outline,
      //title: 'Oops, some thing went wrong',
      title: '@url',
      okText: 'Retry',
      okPressed: () {
        print('ok pressed');
      },
      closeText: 'Close',
      closePressed: () {
        print('close pressed');
      },
      linkText: 'Email Us',
      linkIcon: Icons.mail_outline,
      linkPressed: () {
        print('link pressed');
      },
      message:
//              'Poor network connection detected, Please check your connectivity',
          'This error have been logged and our developer team has been notified. You can try again by click "Retry", or if the error persists, you can contact us using "Email" link')
    ..show(context);
}
*/
