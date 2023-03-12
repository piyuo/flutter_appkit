import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/qrcode/qrcode.dart' as qrcode;
import 'package:auto_size_text/auto_size_text.dart';
import 'error.dart';

/// ErrorScreen show error screen
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    this.backgroundColor = const Color.fromRGBO(203, 29, 57, 1),
    this.onRetry,
    Key? key,
  }) : super(key: key);

  /// backgroundColor is background color of screen
  final Color backgroundColor;

  /// onRetry is callback when retry button clicked
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
          right: false,
          bottom: false,
          child: SingleChildScrollView(
              child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 300, maxWidth: 600),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 64,
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          log.lastException,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          context.i18n.errorNotified,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (onRetry != null)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              minimumSize: const Size(140, 40),
                            ),
                            onPressed: onRetry,
                            child: const Text('Retry'),
                          ),
                        if (onRetry != null) const SizedBox(height: 20),
                        qrcode.Generator(
                          size: 300,
                          data: log.printLastError(),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                            onPressed: () => eventbus.broadcast(EmailSupportEvent()),
                            child: Text(
                              context.i18n.errorEmailUsLink,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ],
                    ),
                  ),
                )),
          ))),
    );
  }
}
