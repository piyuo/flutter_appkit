import 'package:flutter/material.dart';
import 'package:libcli/log.dart' as log;
import 'package:flutter/foundation.dart';
import 'package:libcli/src/pattern/async_provider.dart';
import 'package:libcli/src/pattern/await_progress_indicator.dart';
import 'package:libcli/src/pattern/await_error_message.dart';
import 'package:libcli/support.dart' as support;

const _here = 'await';

/// Await load provider in list
///
class Await extends StatefulWidget {
  final List<AsyncProvider> list;

  final Widget child;

  final Widget error;

  final Widget progress;

  /// Await load provider in list
  ///
  /// show progress indicator when provider still loading
  ///
  /// show error message when provider throw exception
  ///
  /// show child view when provider successfully load
  ///
  Await(
      {Key key,
      @required this.list,
      @required this.child,
      this.progress,
      this.error})
      : super(key: key);

  @override
  _AwaitState createState() => _AwaitState();
}

class _AwaitState extends State<Await> {
  @override
  void initState() {
    Future.microtask(() {
      reload(context);
    });
    super.initState();
  }

  ///status return wait if there is a provider still wait
  ///
  ///return error if provider is error
  ///
  ///others return ready
  AsyncStatus status() {
    for (var p in widget.list) {
      if (p.asyncStatus == AsyncStatus.loading ||
          p.asyncStatus == AsyncStatus.none) {
        return AsyncStatus.loading;
      } else if (p.asyncStatus == AsyncStatus.error) {
        return AsyncStatus.error;
      }
    }
    return AsyncStatus.ready;
  }

  ///errors return provider error record
  ///
  List<support.ErrorRecord> errors() {
    List<support.ErrorRecord> list = List<support.ErrorRecord>();
    for (var p in widget.list) {
      if (p.errorRecord != null) {
        list.add(p.errorRecord);
      }
    }
    return list;
  }

  /// reload provider in list, but skip ready provider
  ///
  void reload(BuildContext context) {
    widget.list.forEach((provider) {
      provider.errorRecord = null;
      if (provider.asyncStatus == AsyncStatus.error) {
        provider.asyncStatus == AsyncStatus.none;
      }

      if (provider.asyncStatus == AsyncStatus.none) {
        provider.asyncStatus = AsyncStatus.loading;
        Future.microtask(() {
          provider.load(context).then((_) {
            debugPrint('$_here~${provider.runtimeType} loaded');
            provider.asyncStatus = AsyncStatus.ready;
            provider.notifyListeners();
          }).catchError((e, s) {
            var errorID = log.error(_here, e, s);
            provider.errorRecord = support.ErrorRecord(errorID, e, s);
            provider.asyncStatus = AsyncStatus.error;
          });
        });
      }
    });
  }

  /// build widget
  ///
  @override
  Widget build(BuildContext context) {
    switch (status()) {
      case AsyncStatus.ready:
        return widget.child;
      case AsyncStatus.error:
        return widget.error != null
            ? widget.error
            : AwaitErrorMessage(records: errors());
      default:
        return widget.progress != null
            ? widget.progress
            : AwaitProgressIndicator();
    }
  }
}
