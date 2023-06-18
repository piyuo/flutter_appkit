import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'refresh_more.dart';

/// LoadMoreAnimateView is load more widget that support animate view
class LoadMoreAnimateView extends StatelessWidget {
  const LoadMoreAnimateView({
    required this.child,
    required this.refreshMoreProvider,
    this.execLoadMore,
    super.key,
  });

  /// onMore load more data, return true if no more data,
  final Future<void> Function()? execLoadMore;

  /// child is the custom scroll view
  final Widget child;

  final RefreshMoreProvider refreshMoreProvider;

  @override
  Widget build(BuildContext context) {
    if (execLoadMore == null) {
      return child;
    }

    if (refreshMoreProvider.isRefreshing) {
      return child;
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        double currentExtent = notification.metrics.pixels;
        double maxExtent = notification.metrics.maxScrollExtent;
        if ((notification is ScrollEndNotification)) {
          bool canLoad = currentExtent >= maxExtent;
          if (canLoad && refreshMoreProvider.moreStatus == LoadingStatus.idle) {
            execLoadMore!();
            return true;
          }
          return false;
        }

        return false;
      },
      child: child,
    );
  }
}

/// addLoadMoreIndicator add load more indicator that support animate view
Widget loadMoreIndicator(
  BuildContext context, {
  required RefreshMoreProvider refreshMoreProvider,
  Future<void> Function()? execLoadMore,
  String errorMsg = 'Load fail, tap to retry',
  String completedMsg = 'no more data',
}) {
  final colorScheme = Theme.of(context).colorScheme;

  Widget buildLoading() {
    return SizedBox(
      width: double.infinity,
      height: kFooterHeight,
      child: Center(
        child: SizedBox(
          width: 110,
          height: 24,
          child: delta.ballPulseIndicator(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Container(
      alignment: Alignment.center,
      height: kFooterHeight,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
        ),
        onPressed: execLoadMore != null ? () => execLoadMore() : null,
        icon: Icon(Icons.error, color: colorScheme.onErrorContainer),
        label: Text(errorMsg, style: TextStyle(color: colorScheme.onErrorContainer)),
      ),
    );
  }

  Widget buildCompleted() {
    return SizedBox(
        height: kFooterHeight,
        child: Center(
          child: Text(completedMsg),
        ));
  }

  Widget buildLoadMore() {
    final status = refreshMoreProvider.moreStatus;
    if (status == LoadingStatus.loading) {
      return buildLoading();
    } else if (status == LoadingStatus.error) {
      return buildError();
    } else if (status == LoadingStatus.completed) {
      return buildCompleted();
    } else {
      return Container(height: kFooterHeight);
    }
  }

  return buildLoadMore();
}
