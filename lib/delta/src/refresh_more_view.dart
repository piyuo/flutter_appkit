import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'extensions.dart';
import 'indicator.dart';

/// RefreshMoreView is list view that support refresh and load more
/// ```dart
///  RefreshMoreView(
///   scrollController: _scrollController,
///   itemCount: items.length,
///   itemBuilder: (BuildContext context, int index) {
///     return ListTile(leading: CircleAvatar(child: Text(item)));
///   },
///   onRefresh: () async {},
///   onLoadMore: () async {},
/// )
/// ```
class RefreshMoreView extends StatefulWidget {
  /// RefreshMoreView is list view that support refresh and load more
  /// ```dart
  ///  RefreshMoreView(
  ///   scrollController: _scrollController,
  ///   itemCount: items.length,
  ///   itemBuilder: (BuildContext context, int index) {
  ///     return ListTile(leading: CircleAvatar(child: Text(item)));
  ///   },
  ///   onRefresh: () async {},
  ///   onLoadMore: () async {},
  /// )
  /// ```
  const RefreshMoreView({
    required this.itemCount,
    required this.itemBuilder,
    Key? key,
    this.onRefresh,
    this.onLoadMore,
    this.scrollController,
  }) : super(key: key);

  /// itemCount is list view item count
  final int itemCount;

  /// itemBuilder is list view item builder
  final Widget Function(BuildContext, int) itemBuilder;

  /// onRefresh is the callback function when user refresh the list
  final Future<void> Function()? onRefresh;

  /// ondLoadMore is the callback function when user load more the list
  final Future<void> Function()? onLoadMore;

  /// scrollController is the scroll controller of the refresh panel
  final ScrollController? scrollController;

  @override
  _RefreshMoreViewState createState() => _RefreshMoreViewState();
}

class _RefreshMoreViewState extends State<RefreshMoreView> {
  /// _busy is true will not execute onRefresh or onLoad
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.itemCount + (widget.onRefresh != null ? 1 : 0) + (widget.onLoadMore != null ? 1 : 0);

    Widget button(String text, Future<void> Function() callback) => OutlinedButton.icon(
          label: Text(text, style: const TextStyle(color: Colors.grey)),
          icon: const Icon(Icons.refresh, color: Colors.grey),
          onPressed: () async {
            setState(() => _busy = true);
            try {
              await callback();
            } finally {
              setState(() => _busy = false);
            }
          },
        );

    Widget indicator() => Align(alignment: Alignment.center, child: SizedBox(height: 28, child: ballPulseIndicator()));

    return context.isTouchSupported
        ? EasyRefresh(
            header: BallPulseHeader(color: Theme.of(context).colorScheme.primary),
            footer: BallPulseFooter(color: Theme.of(context).colorScheme.primary),
            onRefresh: widget.onRefresh,
            onLoad: widget.onLoadMore,
            child: ListView.builder(
              itemCount: widget.itemCount,
              itemBuilder: widget.itemBuilder,
            ),
            scrollController: widget.scrollController,
          )
        : ListView.builder(
            controller: widget.scrollController,
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if (widget.onRefresh != null && index == 0) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: _busy ? indicator() : button('Refresh', widget.onRefresh!));
              }
              if (widget.onLoadMore != null && index == itemCount - 1) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                  child: _busy ? indicator() : button('Load more', widget.onLoadMore!),
                );
              }
              if (widget.onRefresh != null) {
                index--;
              }
              return widget.itemBuilder(context, index);
            },
          );
  }
}
