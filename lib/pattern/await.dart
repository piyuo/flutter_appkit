import 'package:flutter/material.dart';
import 'package:libcli/pattern/async_provider.dart';
import 'package:libcli/pattern/await_provider.dart';

class Await extends StatelessWidget {
  final AwaitProvider provider = AwaitProvider();
  final Widget child;
  final Widget wait;
  final Widget error;

  Await(
      {Key key,
      @required List<AsyncProvider> list,
      @required this.child,
      this.wait,
      this.error})
      : super(key: key) {
    provider.list = list;

    Future.microtask(() {
      provider.reload();
    });
  }

  Widget errorView() {
    if (error != null) {
      return error;
    }
    return Center(
        child: Text('Oops... something is wrong, please try again later'));
  }

  Widget waitView() {
    if (wait != null) {
      return wait;
    }
    return Center(child: CircularProgressIndicator());
  }

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
