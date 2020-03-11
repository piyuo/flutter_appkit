import 'package:flutter/material.dart';
import 'package:libcli/pattern/async_provider.dart';
import 'package:libcli/pattern/await_provider.dart';
import 'package:libcli/log/log.dart';

class Await extends StatelessWidget {
  final AwaitProvider provider = AwaitProvider();
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
      @required List<AsyncProvider> list,
      @required this.child,
      this.wait,
      this.error})
      : super(key: key) {
    provider.list = list;
    'await|list$NOUN(${list.length})'.print;
    Future.microtask(() {
      provider.reload();
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
    switch (provider.status()) {
      case AsyncStatus.ready:
        return child;
      case AsyncStatus.error:
        return errorView();
      default:
        return waitView();
    }
  }
}
