import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:auto_size_text/auto_size_text.dart';
import 'error.dart';

enum WaitStatus { loading, error, ready }

/// Wait for a future to complete
class Wait extends StatefulWidget {
  /// Wait for a future to complete
  ///
  /// show progress indicator when future still loading
  ///
  /// show error message when provider throw exception
  ///
  /// show child view when provider successfully load
  ///
  const Wait({
    required this.future,
    required this.child,
    this.loading,
    this.error,
    Key? key,
  }) : super(key: key);

  /// future to wait
  final Future<void> Function() future;

  /// child to show when future complete
  final Widget child;

  /// error to show when future throw exception
  final Widget? error;

  /// loading to show when future still loading
  final Widget? loading;

  @override
  WaitState createState() => WaitState();
}

class WaitState extends State<Wait> {
  WaitStatus _status = WaitStatus.loading;

  @override
  void initState() {
    Future.microtask(() => load(context));
    super.initState();
  }

  /// load run future and update status
  Future<void> load(BuildContext context) async {
    try {
      await widget.future();
      setState(() {
        _status = WaitStatus.ready;
      });
    } catch (e, s) {
      log.error(e, s);
      setState(() {
        _status = WaitStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case WaitStatus.ready:
        return widget.child;
      case WaitStatus.error:
        return widget.error != null ? widget.error! : const WaitErrorMessage();
      default:
        return widget.loading != null
            ? widget.loading!
            : Scaffold(
                body: Center(
                  child: Icon(
                    Icons.access_time,
                    size: 128,
                    color: context.themeColor(
                      light: Colors.grey.shade300,
                      dark: Colors.grey.shade800,
                    ),
                  ),
                ),
              );
    }
  }
}

/// WaitErrorMessage show error message when wait future throw exception
class WaitErrorMessage extends StatelessWidget {
  const WaitErrorMessage({
    Key? key,
  }) : super(key: key);

  final backgroundColor = const Color.fromRGBO(203, 29, 57, 1);

  @override
  Widget build(BuildContext context) {
    String logs = log.printLogs();
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
            child: Container(
                padding: const EdgeInsets.all(40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 300, maxWidth: 600),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 120,
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        context.i18n.errorTitle,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      AutoSizeText(
                        context.i18n.errorNotified,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        logs,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                          onTap: () => eventbus.broadcast(EmailSupportEvent()),
                          child: Icon(
                            Icons.email,
                            color: Colors.orange[200],
                            size: 38,
                          )),
                      const SizedBox(width: 10),
                      InkWell(
                          onTap: () => eventbus.broadcast(EmailSupportEvent()),
                          child: Text(
                            context.i18n.errorEmailUsLink,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.orange[200],
                              fontSize: 14.0,
                            ),
                          )),
                    ]),
                  ),
                )),
          ))),
    );
  }
}
