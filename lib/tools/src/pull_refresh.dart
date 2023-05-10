import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/log/log.dart' as log;
import 'package:flutter/rendering.dart';
import 'refresh_more.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

/// PullRefresh support pull down refresh and pull up load more
class PullRefresh extends StatelessWidget {
  /// ```dart
  ///  PullToRefresh(
  ///   scrollController: _scrollController,
  ///   onRefresh: () async {},
  ///   onLoadMore: () async {},
  ///   child: ListView.builder(...),
  /// )
  /// ```
  const PullRefresh({
    required this.refreshMoreProvider,
    required this.child,
    this.onRefresh,
    Key? key,
  }) : super(key: key);

  /// refreshMoreProvider control status of load more
  final RefreshMoreProvider refreshMoreProvider;

  /// onRefresh is the callback function when user refresh the list
  final LoadingCallback? onRefresh;

  /// child is the custom scroll view or list view
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (onRefresh == null) {
      return child;
    }
    return CustomRefreshIndicator(
      controller: refreshMoreProvider.refreshController,
      onRefresh: () async {
        try {
          await onRefresh!();
        } catch (e, s) {
          log.error(e, s);
          dialog.showErrorBanner('Load fail, please retry later');
        }
      },
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                if (controller.scrollingDirection == ScrollDirection.reverse &&
                    refreshMoreProvider.prevScrollDirection == ScrollDirection.forward &&
                    controller.isDragging &&
                    controller.isArmed) {
                  controller.stopDrag();
                }

                refreshMoreProvider.prevScrollDirection = controller.scrollingDirection;
                final containerHeight = controller.value * kHeaderHeight;
                return controller.isIdle
                    ? const SizedBox()
                    : Container(
                        alignment: Alignment.center,
                        height: containerHeight,
                        child: OverflowBox(
                          maxHeight: 40,
                          minHeight: 40,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            alignment: Alignment.center,
                            child: delta.ballSpinIndicator(),
                          ),
                        ),
                      );
              },
            ),
            Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.hardEdge,
                child: AnimatedBuilder(
                  builder: (context, _) {
                    return Transform.translate(offset: Offset(0.0, controller.value * kHeaderHeight), child: child);
                  },
                  animation: controller,
                )),
          ],
        );
      },
      child: child,
    );
  }
}
