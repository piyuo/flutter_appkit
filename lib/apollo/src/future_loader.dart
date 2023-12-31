// ignore: depend_on_referenced_packages
import 'package:universal_io/io.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'error_screen.dart';

/// _Status is status of wait future
enum _Status { loading, error, ready }

/// FutureLoader is a function to wait for a future to complete, use notifyListener to update status
typedef Loader = Future<void> Function(VoidCallback notifyListener);

/// [_FutureLoaderProvider] control [FutureLoader]
class _FutureLoaderProvider with ChangeNotifier {
  _FutureLoaderProvider({
    required this.loader,
    required this.allowRetry,
  });

  /// [loader] to wait, return true if success, return false to retry
  final Loader loader;

  /// [allowRetry] is true if allow retry
  final bool allowRetry;

  /// [status] is status of wait future
  _Status status = _Status.loading;

  /// [futureAutoRetried] is true if future already retried automatically
  bool futureAutoRetried = false;

  /// [isNetworkError] is true if error is network error or retry error
  bool isNetworkError(e) {
    return e is SocketException || e is TimeoutException || e is utils.TryAgainLaterException;
  }

  /// load run future and update status
  Future<void> _init(VoidCallback? popHandler) async {
    try {
      await loader(notifyListeners);
      status = _Status.ready;
    } catch (e, s) {
      if (isNetworkError(e) && allowRetry && !futureAutoRetried) {
        futureAutoRetried = true;
        await retry(popHandler);
        return;
      }
      log.error(e, s);
      status = _Status.error;
    }
    notifyListeners();
  }

  /// retry run future again
  Future<void> retry(VoidCallback? popHandler) async {
    try {
      status = _Status.loading;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 3));
      await loader(notifyListeners);
    } catch (e, s) {
      log.error(e, s);
      final result = await dialog.show(
        iconBuilder: (context) => Icon(Icons.wifi_off, size: 64, color: Theme.of(context).colorScheme.onError),
        title: 'Please check your internet connection',
        contentBuilder: (context) => AutoSizeText(
          log.lastExceptionMessage!,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        type: popHandler != null ? dialog.DialogButtonsType.yesNo : dialog.DialogButtonsType.yes,
        yesText: 'Retry',
        noText: 'Go back',
        barrierDismissible: false,
        isError: true,
      );
      if (result == true) {
        await retry(popHandler);
        return;
      }
      if (popHandler != null) {
        popHandler();
        return;
      }
    }
    notifyListeners();
  }
}

/// [FutureLoader] wait for a future to complete
class FutureLoader extends StatelessWidget {
  /// Wait for a future to complete
  ///
  /// show progress indicator when future still loading
  ///
  /// show error message when provider throw exception
  ///
  /// show child view when provider successfully load
  ///
  const FutureLoader({
    required this.loader,
    required this.builder,
    this.allowRetry = true,
    super.key,
  });

  /// [loader] to wait, return true if success, return false to retry
  final Loader loader;

  /// [builder] build widget to show when future complete
  final Widget Function(bool isReady) builder;

  /// [allowRetry] is true if allow retry when future throw exception
  final bool allowRetry;

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final popHandler = navigator.canPop() ? () => navigator.pop() : null;
    return ChangeNotifierProvider<_FutureLoaderProvider>(
        create: (_) => _FutureLoaderProvider(
              loader: loader,
              allowRetry: allowRetry,
            ).._init(popHandler),
        child: Consumer<_FutureLoaderProvider>(
          builder: (context, loadingScreenProvider, child) {
            switch (loadingScreenProvider.status) {
              case _Status.ready:
                return builder(true);
              case _Status.error:
                return ErrorScreen(onRetry: allowRetry ? () => loadingScreenProvider.retry(popHandler) : null);
              default:
                return builder(false);
            }
          },
        ));
  }
}

/// [LoadingScreen] show loading screen
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Icon(
          Icons.access_time,
          size: 128,
        ),
      ),
    );
  }
}
