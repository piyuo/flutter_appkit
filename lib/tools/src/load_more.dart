import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/delta/delta.dart' as delta;
import 'refresh_more.dart';

/// _keyLastItem is key on last item
const Key _keyLastItem = Key("_LAST");

class LoadMore extends StatelessWidget {
  const LoadMore({
    required this.refreshMoreProvider,
    required this.child,
    this.errorMsg = 'Load fail, tap to retry',
    this.completedMsg = 'no more data',
    this.onMore,
    super.key,
  });

  /// refreshMoreProvider control status of load more
  final RefreshMoreProvider refreshMoreProvider;

  /// onMore load more data, return true if no more data,
  final Future<void> Function()? onMore;

  ///Text displayed in case of error
  final String errorMsg;

  ///Text displayed when loading is finished
  final String completedMsg;

  /// child is the custom scroll view
  final CustomScrollView child;

  @override
  Widget build(BuildContext context) {
    if (onMore == null) {
      return child;
    }

    final colorScheme = Theme.of(context).colorScheme;
    execLoadMore() async {
      refreshMoreProvider.setMoreStatus(LoadingStatus.loading);
      try {
        await onMore!();
        refreshMoreProvider.setMoreStatus(LoadingStatus.idle);
      } catch (e, s) {
        log.error(e, s);
        refreshMoreProvider.setMoreStatus(LoadingStatus.error);
      }
    }

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
          onPressed: () => execLoadMore(),
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

    dynamic check = child.slivers.elementAt(child.slivers.length - 1);
    if (check is SliverSafeArea && check.key == _keyLastItem) {
      child.slivers.removeLast();
    }

    child.slivers.add(
      SliverSafeArea(
        key: _keyLastItem,
        top: false,
        left: false,
        right: false,
        sliver: SliverToBoxAdapter(
          child: buildLoadMore(),
        ),
      ),
    );
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
            execLoadMore();
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

void addLoadMoreMark(
  BuildContext context, {
  required RefreshMoreProvider refreshMoreProvider,
  Future<void> Function()? onMore,
  String errorMsg = 'Load fail, tap to retry',
  String completedMsg = 'no more data',
  required List<Widget> list,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  execLoadMore() async {
    refreshMoreProvider.setMoreStatus(LoadingStatus.loading);
    try {
      await onMore!();
      refreshMoreProvider.setMoreStatus(LoadingStatus.idle);
    } catch (e, s) {
      log.error(e, s);
      refreshMoreProvider.setMoreStatus(LoadingStatus.error);
    }
  }

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
        onPressed: () => execLoadMore(),
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

  dynamic check = list.elementAt(list.length - 1);
  if (check is SliverSafeArea && check.key == _keyLastItem) {
    list.removeLast();
  }

  list.add(
    SliverSafeArea(
      key: _keyLastItem,
      top: false,
      left: false,
      right: false,
      sliver: SliverToBoxAdapter(
        child: buildLoadMore(),
      ),
    ),
  );
}
