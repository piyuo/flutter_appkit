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
    this.onRetry,
    Key? key,
  }) : super(key: key);

  /// onRetry is callback when retry button clicked
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        title: Text(
          'Oops! Something went wrong',
          style: TextStyle(color: colorScheme.onError),
        ),
      ),
      backgroundColor: colorScheme.error,
      body: SafeArea(
          right: false,
          bottom: false,
          child: SingleChildScrollView(
              child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 300, maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        log.lastExceptionToString,
                        maxLines: 2,
                        style: TextStyle(
                          color: colorScheme.onError,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        context.i18n.errorNotified,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (onRetry != null)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: colorScheme.onErrorContainer,
                            backgroundColor: colorScheme.errorContainer,
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
                            style: TextStyle(color: colorScheme.onError),
                          )),
                    ],
                  ),
                )),
          ))),
    );
  }
}
