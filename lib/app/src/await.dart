import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:auto_size_text/auto_size_text.dart';
import 'error.dart';

/// Await load provider in list
class Await extends StatefulWidget {
  final List<delta.AsyncProvider> list;

  final Widget child;

  final Widget? error;

  final Widget? progress;

  /// Await load provider in list
  ///
  /// show progress indicator when provider still loading
  ///
  /// show error message when provider throw exception
  ///
  /// show child view when provider successfully load
  ///
  const Await(
    this.list, {
    Key? key,
    required this.child,
    this.progress,
    this.error,
  }) : super(key: key);

  @override
  AwaitState createState() => AwaitState();
}

class AwaitState extends State<Await> {
  @override
  void initState() {
    Future.microtask(() => reload(context));
    super.initState();
  }

  /// status return wait if there is a provider need wait, return error if provider is error
  delta.AsyncStatus status() {
    for (var p in widget.list) {
      if (p.asyncStatus == delta.AsyncStatus.loading || p.asyncStatus == delta.AsyncStatus.none) {
        log.log('[await] loading');
        return delta.AsyncStatus.loading;
      } else if (p.asyncStatus == delta.AsyncStatus.error) {
        log.log('[await] error');
        return delta.AsyncStatus.error;
      }
    }
    log.log('[await] ready');
    return delta.AsyncStatus.ready;
  }

  /// reload provider in list, but skip ready provider
  ///
  void reload(BuildContext context) {
    for (var provider in widget.list) {
      if (provider.asyncStatus == delta.AsyncStatus.error) {
        log.log('[await] reload ${provider.runtimeType}');
        provider.asyncStatus = delta.AsyncStatus.none;
      }

      if (provider.asyncStatus == delta.AsyncStatus.none) {
        provider.asyncStatus = delta.AsyncStatus.loading;
        Future.microtask(() {
          provider.load(context).then((_) {
            provider.asyncStatus = delta.AsyncStatus.ready;
            provider.notifyListeners();
            log.log('[await] ${provider.runtimeType} loaded');
          }).catchError((e, s) async {
            log.error(e, s);
            provider.asyncStatus = delta.AsyncStatus.error;
            provider.notifyListeners();
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (status()) {
      case delta.AsyncStatus.ready:
        return widget.child;
      case delta.AsyncStatus.error:
        return widget.error != null ? widget.error! : const AwaitErrorMessage();
      default:
        return widget.progress != null
            ? widget.progress!
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

class AwaitErrorMessage extends StatelessWidget {
  final backgroundColor = const Color.fromRGBO(203, 29, 57, 1);

  const AwaitErrorMessage({Key? key}) : super(key: key);

  content(BuildContext context) {
    return Container(
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
            fontSize: 18.0,
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
    );
  }

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
            child: Container(
                padding: const EdgeInsets.all(40),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 300, maxWidth: 360), child: content(context))),
          ))),
    );
  }
}
