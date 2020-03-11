import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:libcli/pattern/async_provider.dart';

const _here = 'await_provider';

class AwaitProvider with ChangeNotifier {
  List<AsyncProvider> list;

  ///status return wait if there is a provider still wait
  ///
  ///return error if provider is error
  ///
  ///others return ready
  AsyncStatus status() {
    for (var p in list) {
      if (p.asyncStatus == AsyncStatus.wait) {
        return AsyncStatus.wait;
      } else if (p.asyncStatus == AsyncStatus.error) {
        return AsyncStatus.error;
      }
    }
    return AsyncStatus.ready;
  }

  /// reload provider in list, but skip ready provider
  ///
  void reload() {
    '$_here|reload list$NOUN(${list.length})'.print;
    list.forEach((provider) {
      if (provider.asyncStatus == AsyncStatus.error) {
        provider.asyncStatus == AsyncStatus.wait;
      }

      if (provider.asyncStatus == AsyncStatus.wait) {
        Future.microtask(() {
          provider.load().then((_) {
            '$here|load $NOUN${provider.runtimeType}'.print;
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
}
