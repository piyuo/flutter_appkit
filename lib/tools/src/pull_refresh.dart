import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/log/log.dart' as log;
import 'package:flutter/rendering.dart';
import 'refresh_more.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

/// PullRefresh support pull down refresh and pull up load more
class PullRefresh extends StatelessWidget {
  /// PullRefresh support pull down refresh and pull up load more
  /// ```dart
  ///  PullRefresh(
  ///   onRefresh: () async {},
  ///   child: ...,
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

                if (controller.isDragging || controller.isArmed) {
                  return Transform.translate(
                      offset: Offset(0.0, controller.value * kHeaderHeight - 30),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Icon(
                          controller.isArmed ? Icons.swap_vert : Icons.arrow_downward,
                          size: 40,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ));
                }

                if (refreshMoreProvider.isRefreshAnimation || controller.isSettling || controller.isLoading) {
                  return Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        height: kHeaderHeight,
                        child: delta.ballSpinIndicator(),
                      ));
                }
                return const SizedBox();
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
