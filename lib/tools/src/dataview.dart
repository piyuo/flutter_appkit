import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/pb/pb.dart' as pb;
import 'refresh_more.dart';
import 'pull_refresh.dart';
import 'load_more_animate_view.dart';

/// DataviewProvider is a provider for [Dataview]
class DataviewProvider<T extends pb.Object> with ChangeNotifier {
  /// animateViewProvider for animation
  delta.AnimateViewProvider animateViewProvider = delta.AnimateViewProvider();

  Future<void> init(data.DataProvider<T> dataProvider) async {
    animateViewProvider.setLength(dataProvider.displayRows.length + 2); // 1 for header, 1 for load more
  }

  /// onRefresh is called when dataview pull to refresh
  void onRefresh(
    Widget Function(T) widgetBuilder,
    data.ChangeFinder<T> changed,
    data.DataProvider<T> dataProvider,
  ) {
    debugPrint('insertCount:${changed.insertCount}');
    // handle new insert
    animateViewProvider.insertAnimation(
      index: 1,
      count: changed.insertCount,
    );

    for (int i = changed.removed.entries.length - 1; i >= 0; i--) {
      final entry = changed.removed.entries.elementAt(i);
      debugPrint('remove:${entry.key}');
      Widget removedWidget = widgetBuilder(entry.value);
      animateViewProvider.removeAnimation(
        entry.key + 1,
        removedWidget,
        //      duration: const Duration(milliseconds: 3500),
      );
    }

    notifyListeners();
  }

  /// onFetchMore is called when dataview fetch more data
  void onFetchMore(
    data.DataProvider<T> dataProvider,
    delta.AnimateViewProvider animateViewProvider,
  ) {
    animateViewProvider.setLength(dataProvider.displayRows.length + 2); // 1 for header, 1 for load more
    notifyListeners();
  }

  /// dispose database
  @override
  void dispose() {
    super.dispose();
    animateViewProvider.dispose();
  }
}

/// Dataview provide a view to show data
class Dataview<T extends pb.Object> extends StatelessWidget {
  const Dataview({
    required this.widgetBuilder,
    required this.dataProvider,
    required this.dataviewProvider,
    this.headerBuilder,
    super.key,
  });

  /// headerBuilder can be search box or other widget
  final Widget Function()? headerBuilder;

  /// widgetBuilder return widget to show data
  final Widget Function(T) widgetBuilder;

  // dataProvider is instance of [DataProvider]
  final data.DataProvider<T> dataProvider;

  // dataviewProvider is instance of [DataviewProvider]
  final DataviewProvider<T> dataviewProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RefreshMoreProvider>(
            create: (context) => RefreshMoreProvider(),
          ),
          ChangeNotifierProvider<delta.AnimateViewProvider>.value(
            value: dataviewProvider.animateViewProvider,
          ),
        ],
        child: Consumer2<RefreshMoreProvider, delta.AnimateViewProvider>(
            builder: (context, refreshMoreProvider, animateViewProvider, child) {
          execLoadMore() async {
            refreshMoreProvider.setMoreStatus(LoadingStatus.loading);
            try {
              bool hasMore = await dataProvider.fetch(notify: false);
              if (hasMore) {
                dataviewProvider.onFetchMore(dataProvider, animateViewProvider);
              }
              refreshMoreProvider.setMoreStatus(LoadingStatus.idle);
            } catch (e, s) {
              log.error(e, s);
              refreshMoreProvider.setMoreStatus(LoadingStatus.error);
            }
          }

          return PullRefresh(
            refreshMoreProvider: refreshMoreProvider,
            onRefresh: () async {
              final changed = await dataProvider.refresh(findDifference: true, notify: false);
              if (changed!.isChanged) {
                dataviewProvider.onRefresh(
                  widgetBuilder,
                  changed,
                  dataProvider,
                );
              }
            },
            child: LoadMoreAnimateView(
                refreshMoreProvider: refreshMoreProvider,
                execLoadMore: dataProvider.isMoreToFetch ? execLoadMore : null,
                child: dataProvider.displayRows.isEmpty
                    ? const delta.NoDataDisplay()
                    : delta.AnimateView(
                        animateViewProvider: animateViewProvider,
                        itemBuilder: (index) => index == 0
                            ? headerBuilder != null
                                ? SizedBox(width: double.infinity, child: headerBuilder!())
                                : const SizedBox()
                            : index - 1 == dataProvider.displayRows.length
                                ? loadMoreIndicator(
                                    context,
                                    refreshMoreProvider: refreshMoreProvider,
                                    execLoadMore: dataProvider.isMoreToFetch ? execLoadMore : null,
                                  )
                                : widgetBuilder(dataProvider.displayRows[index - 1]),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 20,
                        crossAxisCount: 1,
                      )),
          );
        }));
  }
}
