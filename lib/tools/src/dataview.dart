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

  /// dataProvider is instance of [DataProvider]
  late data.DataProvider<T> dataProvider;

  /// selectedRows keep track selected rows
  List<T> selectedRows = [];

  Future<void> init(data.DataProvider<T> newDataProvider) async {
    dataProvider = newDataProvider;
    animateViewProvider.setLength(dataProvider.displayRows.length + 2); // 1 for header, 1 for load more
  }

  /// Widget called when dataview pull to refresh
  Future<void> refresh(Widget Function(T) widgetBuilder) async {
    final backup = List<T>.from(dataProvider.displayRows);
    await dataProvider.refresh(notify: false);
    final changed = data.ChangeFinder<T>();
    changed.refreshDifference(source: backup, target: dataProvider.displayRows);

    if (!changed.isChanged) {
      return;
    }

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

  /// fetch is called when dataview fetch more data
  Future<void> fetch() async {
    bool hasMore = await dataProvider.fetch(notify: false);
    if (!hasMore) {
      return;
    }
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
    required this.viewProvider,
    this.headerBuilder,
    super.key,
  });

  /// headerBuilder can be search box or other widget
  final Widget Function()? headerBuilder;

  /// widgetBuilder return widget to show data
  final Widget Function(T) widgetBuilder;

  // viewProvider is instance of [DataviewProvider]
  final DataviewProvider<T> viewProvider;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<RefreshMoreProvider>(
            create: (context) => RefreshMoreProvider(),
          ),
          ChangeNotifierProvider<delta.AnimateViewProvider>.value(
            value: viewProvider.animateViewProvider,
          ),
        ],
        child: Consumer2<RefreshMoreProvider, delta.AnimateViewProvider>(
            builder: (context, refreshMoreProvider, animateViewProvider, child) {
          Future<void> goFetch() async {
            refreshMoreProvider.setMoreStatus(LoadingStatus.loading);
            try {
              await viewProvider.fetch();
              refreshMoreProvider.setMoreStatus(LoadingStatus.idle);
            } catch (e, s) {
              log.error(e, s);
              refreshMoreProvider.setMoreStatus(LoadingStatus.error);
            }
          }

          return PullRefresh(
            refreshMoreProvider: refreshMoreProvider,
            onRefresh: () async => await viewProvider.refresh(widgetBuilder),
            child: LoadMoreAnimateView(
                refreshMoreProvider: refreshMoreProvider,
                execLoadMore: viewProvider.dataProvider.isMoreToFetch ? goFetch : null,
                child: viewProvider.dataProvider.displayRows.isEmpty
                    ? const delta.NoDataDisplay()
                    : delta.AnimateView(
                        animateViewProvider: animateViewProvider,
                        itemBuilder: (index) => index == 0
                            ? headerBuilder != null
                                ? SizedBox(width: double.infinity, child: headerBuilder!())
                                : const SizedBox()
                            : index - 1 == viewProvider.dataProvider.displayRows.length
                                ? loadMoreIndicator(
                                    context,
                                    refreshMoreProvider: refreshMoreProvider,
                                    execLoadMore: viewProvider.dataProvider.isMoreToFetch ? goFetch : null,
                                  )
                                : widgetBuilder(viewProvider.dataProvider.displayRows[index - 1]),
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 20,
                        crossAxisCount: 1,
                      )),
          );
        }));
  }
}
