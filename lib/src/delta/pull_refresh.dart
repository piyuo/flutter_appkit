import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'extensions.dart';

typedef PullRefreshLoader = Future<void> Function(BuildContext context);

class PullRefreshProvider with ChangeNotifier {
  /// _busy is true if in refresh or load more
  bool _busy = false;

  void setBusy(bool busy) {
    if (_busy != busy) {
      _busy = busy;
      notifyListeners();
    }
  }
}

class PullRefresh extends StatelessWidget {
  const PullRefresh({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection = Axis.vertical,
    this.onPullRefresh,
    this.onLoadMore,
  }) : super(key: key);

  final Axis scrollDirection;

  /// onPullRefresh mean pull to refresh, return true if count change
  final PullRefreshLoader? onPullRefresh;

  /// onLoadMore mean scroll down to load more, return true if count change
  final PullRefreshLoader? onLoadMore;

  /// itemBuilder build widget
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// itemCount return total item count
  final int Function(BuildContext context) itemCount;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PullRefreshProvider>(
        create: (context) => PullRefreshProvider(),
        child: Consumer<PullRefreshProvider>(builder: (context, provide, child) {
          return EasyRefresh(
            header: scrollDirection == Axis.vertical
                ? BallPulseHeader(
                    color: context.themeColor(light: Colors.grey),
                  )
                : MaterialHeader(),
            footer: scrollDirection == Axis.vertical
                ? BallPulseFooter(
                    color: context.themeColor(light: Colors.grey[400]!, dark: Colors.grey[600]!),
                  )
                : MaterialFooter(),
            onRefresh: onPullRefresh != null
                ? () async {
                    if (provide._busy) {
                      return;
                    }

                    provide.setBusy(true);
                    try {
                      await onPullRefresh!(context);
                    } finally {
                      provide.setBusy(false);
                    }
                  }
                : null,
            onLoad: onLoadMore != null
                ? () async {
                    if (provide._busy) {
                      return;
                    }

                    provide.setBusy(true);
                    try {
                      await onLoadMore!(context);
                    } finally {
                      provide.setBusy(false);
                    }
                  }
                : null,
            child: ListView.builder(
              scrollDirection: scrollDirection,
              //             shrinkWrap: true,
              itemBuilder: itemBuilder,
              itemCount: itemCount(context),
            ),
          );
        }));
  }
}
