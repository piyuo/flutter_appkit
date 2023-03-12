import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:auto_size_text/auto_size_text.dart';

/// NetworkErrorScreen show error screen
class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({
    this.backgroundColor = Colors.blue,
    required this.onRetry,
    Key? key,
  }) : super(key: key);

  /// backgroundColor is background color of screen
  final Color backgroundColor;

  /// onRetry is callback when retry button clicked
  final VoidCallback onRetry;

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
                          Icons.wifi,
                          color: Colors.white,
                          size: 96,
                        ),
                        const SizedBox(height: 20),
                        const AutoSizeText(
                          'Please check your internet connection',
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 26.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AutoSizeText(
                          log.lastExceptionMessage!,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            minimumSize: const Size(140, 40),
                          ),
                          onPressed: onRetry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )),
          ))),
    );
  }
}
