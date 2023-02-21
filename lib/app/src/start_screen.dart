import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/delta/delta.dart' as delta;
import 'error_screen.dart';
import 'network_error_screen.dart';

/// RetryableException is a error that can be retried
class RetryableException implements Exception {
  /// RetryNetworkException is a network error that can be retried
  /// [message] is error message
  const RetryableException(this.message);

  /// message is error message
  final String message;

  @override
  String toString() => 'RetryableException: $message';
}

/// _Status is status of wait future
enum _Status { loading, error, networkError, ready }

/// _StartScreenProvider control [StartScreen]
class _StartScreenProvider with ChangeNotifier {
  _StartScreenProvider(this.future, this.allowRetry) {
    Future.microtask(load);
  }

  /// future to wait, return true if success, return false to retry
  final Future<void> Function() future;

  /// allowRetry is true if allow retry
  final bool allowRetry;

  /// status is status of wait future
  _Status status = _Status.loading;

  /// futureAutoRetried is true if future already retried automatically
  bool futureAutoRetried = false;

  /// isNetworkError is true if error is network error or retry error
  bool isNetworkError(e) {
    return e is SocketException || e is TimeoutException || e is RetryableException;
  }

  /// load run future and update status
  Future<void> load() async {
    try {
      await future();
      status = _Status.ready;
    } catch (e, s) {
      if (isNetworkError(e) && allowRetry && !futureAutoRetried) {
        futureAutoRetried = true;
        await retry();
        return;
      }
      log.error(e, s);
      status = isNetworkError(e) ? _Status.networkError : _Status.error;
    }
    notifyListeners();
  }

  /// retry run future again
  Future<void> retry() async {
    try {
      status = _Status.loading;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 3));
      await future();
    } catch (e, s) {
      log.error(e, s);
      status = isNetworkError(e) ? _Status.networkError : _Status.error;
    }
    notifyListeners();
  }
}

/// StartScreen wait for a future to complete
class StartScreen extends StatelessWidget {
  /// Wait for a future to complete
  ///
  /// show progress indicator when future still loading
  ///
  /// show error message when provider throw exception
  ///
  /// show child view when provider successfully load
  ///
  const StartScreen({
    required this.future,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.networkErrorBuilder,
    this.allowRetry = true,
    Key? key,
  }) : super(key: key);

  /// future to wait, return true if success, return false to retry
  final Future<void> Function() future;

  /// builder build widget to show when future complete
  final Widget Function() builder;

  /// errorBuilder build widget to show when future throw exception
  final Widget Function()? errorBuilder;

  /// networkErrorBuilder build widget to show when future throw network exception
  final Widget Function()? networkErrorBuilder;

  /// loadingBuilder build widget to show when future still loading
  final Widget Function()? loadingBuilder;

  /// allowRetry is true if allow retry when future throw exception
  final bool allowRetry;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_StartScreenProvider>(
        create: (_) => _StartScreenProvider(future, allowRetry),
        child: Consumer<_StartScreenProvider>(
          builder: (context, startScreenProvider, child) {
            switch (startScreenProvider.status) {
              case _Status.ready:
                return builder();
              case _Status.error:
                return errorBuilder != null
                    ? errorBuilder!()
                    : ErrorScreen(onRetry: allowRetry ? startScreenProvider.retry : null);
              case _Status.networkError:
                return networkErrorBuilder != null
                    ? networkErrorBuilder!()
                    : NetworkErrorScreen(onRetry: startScreenProvider.retry);
              default:
                return loadingBuilder != null
                    ? loadingBuilder!()
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
          },
        ));
  }
}
