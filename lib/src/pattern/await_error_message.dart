import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:auto_size_text/auto_size_text.dart';

class AwaitErrorMessage extends StatelessWidget {
  final Function onEmailLinkPressed;

  final Function onRetryPressed;

  AwaitErrorMessage({this.onEmailLinkPressed, this.onRetryPressed});

  String get ErrorTitle {
    switch (i18n.localeID) {
      case 'zh_TW':
        return '糟糕，有東西出錯了';
      case 'zh-CN':
        return '糟了，有东西出错';
    }
    return 'Oops, some thing went wrong';
  }

  String get ErrorMessage {
    switch (i18n.localeID) {
      case 'zh_TW':
        return '發生的錯誤已被記錄並且通知了我們的開發團隊，您可以按下方 "重試" 按鈕再試一遍，如果錯誤一直發生，您可以用下方 "電子郵件" 按鈕，直接聯繫我們';
      case 'zh-CN':
        return '发生的错误已被记录并且通知了我们的开发团队，您可以按下方 "重试" 按钮再试一遍，如果错误一直发生，您可以用下方 "电子邮件" 按钮，直接联系我们';
    }
    return 'This error have been logged and our developer team has been notified. You can try again by click "Retry", or if the error persists, you can contact us using "Email" link';
  }

  String get ErrorEmail {
    switch (i18n.localeID) {
      case 'zh_TW':
        return '電子郵件';
      case 'zh-CN':
        return '电子邮件';
    }
    return 'Email';
  }

  String get ErrorRetry {
    switch (i18n.localeID) {
      case 'zh_TW':
        return '重試';
      case 'zh_CN':
        return '重试';
    }
    return 'Retry';
  }

  content(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      //alignment: Alignment.center,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 120,
            ),
            SizedBox(height: 10),
            AutoSizeText(
              ErrorTitle,
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              ErrorMessage,
              maxLines: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[100],
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 40),
            InkWell(
                onTap: onEmailLinkPressed,
                child: Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                  size: 35,
                )),
            InkWell(
                onTap: onEmailLinkPressed,
                child: Text(
                  ErrorEmail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[100],
                    fontSize: 14.0,
                  ),
                )),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: RaisedButton(
                padding: EdgeInsets.all(0.0),
                color: Colors.white,
                child:
                    Text(ErrorRetry, style: TextStyle(color: Colors.red[700])),
                onPressed: onRetryPressed,
              ),
            )
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(203, 29, 57, 1),
      body: SafeArea(
          right: false,
          bottom: false,
          child: SingleChildScrollView(
              child: Center(
            child: Container(
                padding: EdgeInsets.all(40),
                child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 300, maxWidth: 360),
                    child: content(context))),
          ))),
    );
  }
}
