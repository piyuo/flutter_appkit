import 'package:flutter/material.dart';
import 'package:libcli/pattern/async_provider.dart';
import 'package:libcli/log/log.dart';

const _here = 'await';

/// Await load provider in list
///
class Await extends StatelessWidget {
  final List<AsyncProvider> list;
  final Widget child;
  final Widget wait;
  final Widget error;

  /// Await load provider in list
  ///
  /// show wait view when provider still loading
  ///
  /// show error view when provider has error
  ///
  /// show child view when provider successfully load
  ///
  Await(
      {Key key,
      @required this.list,
      @required this.child,
      this.wait,
      this.error})
      : super(key: key) {
    'await|list$NOUN(${list.length})'.print;
    Future.microtask(() {
      reload();
    });
  }

  ///status return wait if there is a provider still wait
  ///
  ///return error if provider is error
  ///
  ///others return ready
  AsyncStatus status() {
    for (var p in list) {
      if (p.asyncStatus == AsyncStatus.loading ||
          p.asyncStatus == AsyncStatus.none) {
        return AsyncStatus.loading;
      } else if (p.asyncStatus == AsyncStatus.error) {
        return AsyncStatus.error;
      }
    }
    return AsyncStatus.ready;
  }

  /// reload provider in list, but skip ready provider
  ///
  void reload() {
    list.forEach((provider) {
      if (provider.asyncStatus == AsyncStatus.error) {
        provider.asyncStatus == AsyncStatus.none;
      }

      if (provider.asyncStatus == AsyncStatus.none) {
        provider.asyncStatus == AsyncStatus.loading;
        Future.microtask(() {
          provider.load().then((_) {
            '$here|${provider.runtimeType} ${NOUN}loaded'.print;
            provider.asyncStatus = AsyncStatus.ready;
            provider.notifyListeners();
          }).catchError((e, s) {
            here.error(e, s);
            provider.asyncStatus = AsyncStatus.error;
          });
        });
      }
    });
  }

  /// errorView when provider has error
  ///
  Widget errorView() {
    if (error != null) {
      return error;
    }
    return Center(
        child: Text('Oops... something is wrong, please try again later'));
  }

  /// waitView when provider still loading
  ///
  Widget waitView() {
    if (wait != null) {
      return wait;
    }
    return Center(child: CircularProgressIndicator());
  }

  /// build widget
  ///
  @override
  Widget build(BuildContext context) {
    switch (status()) {
      case AsyncStatus.ready:
        return child;
      case AsyncStatus.error:
        return errorView();
      default:
        return waitView();
    }
  }
}
