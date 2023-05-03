import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'delta.dart';

/// RefreshView support pull down refresh and pull up load more
class RefreshView extends StatefulWidget {
  /// ```dart
  ///  RefreshMoreView(
  ///   scrollController: _scrollController,
  ///   onRefresh: () async {},
  ///   onLoadMore: () async {},
  ///   child: ListView.builder(...),
  /// )
  /// ```
  const RefreshView({
    required this.child,
    Key? key,
    this.onRefresh,
    this.onLoadMore,
    this.scrollController,
  }) : super(key: key);

  /// onRefresh is the callback function when user refresh the list
  final Future<void> Function()? onRefresh;

  /// ondLoadMore is the callback function when user load more the list
  final Future<void> Function()? onLoadMore;

  /// scrollController is the scroll controller of the refresh panel
  final ScrollController? scrollController;

  final Widget child;

  @override
  RefreshViewState createState() => RefreshViewState();
}

class RefreshViewState extends State<RefreshView> {
  @override
  Widget build(BuildContext context) {
    if (!context.isTouchSupported || (widget.onRefresh == null && widget.onLoadMore == null)) {
      return widget.child;
    }

    return EasyRefresh(
      //set header or footer to null if no onRefresh or onLoad, will force list bounce
      header: widget.onRefresh != null
          ? CupertinoHeader(
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            )
          : null,
      footer:
          widget.onLoadMore != null ? CupertinoFooter(foregroundColor: Theme.of(context).colorScheme.primary) : null,
      onRefresh: widget.onRefresh,
      onLoad: widget.onLoadMore,
      scrollController: widget.scrollController,
      child: widget.child,
    );
  }
}


/*
  /// _busy is true will not execute onRefresh or onLoad
  bool _busy = false;

    int itemCount = widget.itemCount + (widget.onRefresh != null ? 1 : 0) + (widget.onLoadMore != null ? 1 : 0);
    Widget button(String text, Future<void> Function() callback) => TextButton.icon(
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

    Widget indicator() => Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 28,
          child: ballPulseIndicator(),
        ));

ListView.builder(
            controller: widget.scrollController,
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              if (widget.onRefresh != null && index == 0) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                    child: _busy ? indicator() : button('Refresh', widget.onRefresh!));
              }
              if (widget.onLoadMore != null && index == itemCount - 1) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
                  child: _busy ? indicator() : button('Load more', widget.onLoadMore!),
                );
              }
              if (widget.onRefresh != null) {
                index--;
              }
              return widget.itemBuilder(context, index);
            },
          )

 */