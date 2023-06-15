import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'pull_refresh.dart';
import 'load_more.dart';

/// kHeaderHeight is height of header that show refresh indicator
const kHeaderHeight = 50.0;

/// kFooterHeight is height of footer that show load more indicator
const kFooterHeight = 40.0;

/// LoadingCallback return true if no more data
typedef LoadingCallback = Future<dynamic> Function();

/// LoadingStatus is status of load more
enum LoadingStatus {
  idle,
  error,
  loading,
  completed,
}

/// RefreshMoreProvider control status of load more and pull to refresh
class RefreshMoreProvider with ChangeNotifier {
  /// moreStatus is status of load more
  LoadingStatus moreStatus = LoadingStatus.idle;

  /// prevScrollDirection is previous scroll direction for pull to refresh
  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  /// refreshController is controller for pull to refresh
  IndicatorController? refreshController = IndicatorController();

  /// _refreshAnimation is true will let PullRefresh show refresh animation
  bool _isRefreshAnimation = false;

  /// _animationTimer use for refresh animation
  Timer? _animationTimer;

  /// animationValue use for refresh animation
  double _animationValue = 0.0;

  @override
  void dispose() {
    _animationTimer?.cancel();
    refreshController?.dispose();
    refreshController = null;
    super.dispose();
  }

  /// isRefreshing return true if pull to refresh is refreshing
  bool get isRefreshing {
    return refreshController == null ? false : refreshController!.isLoading;
  }

  /// setMoreStatus set status of load more
  void setMoreStatus(LoadingStatus newStatus) {
    refreshController?.enableRefresh();
    moreStatus = newStatus;
    if (moreStatus == LoadingStatus.loading) {
      refreshController?.disableRefresh();
    }
    notifyListeners();
  }

  /// showRefreshAnimation set to true will let PullRefresh show refresh animation
  void showRefreshAnimation(bool start) {
    if (_isRefreshAnimation == start) {
      return;
    }
    _isRefreshAnimation = start;
    notifyListeners();

    if (_animationTimer != null) {
      _animationTimer!.cancel();
    }
    _animationTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      const animationStep = 0.16;

      if (start) {
        refreshController?.disableRefresh();
        _animationValue += animationStep;
      } else {
        _animationValue -= animationStep;
      }

      if (_animationValue >= 1.0) {
        _animationValue = 1.0;
        _animationTimer?.cancel();
      }

      if (_animationValue <= 0) {
        refreshController?.enableRefresh();
        _animationValue = 0;
        _animationTimer?.cancel();
      }
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      refreshController!.setValue(_animationValue);
    });
  }

  /// refreshAnimation set to true will let PullRefresh show refresh animation
  bool get isRefreshAnimation => _isRefreshAnimation;
}

/// RefreshMore support pull down refresh and pull up load more
class RefreshMore extends StatelessWidget {
  const RefreshMore({
    required this.child,
    required this.refreshMoreProvider,
    this.onRefresh,
    this.onMore,
    super.key,
  });

  /// onRefresh is the callback function when user refresh the list
  final LoadingCallback? onRefresh;

  /// onMore is the callback function when user load more
  final LoadingCallback? onMore;

  /// refreshMoreProvider control status of [RefreshMore]
  final RefreshMoreProvider refreshMoreProvider;

  /// child is the custom scroll view
  final CustomScrollView child;

  @override
  Widget build(BuildContext context) {
    return PullRefresh(
        refreshMoreProvider: refreshMoreProvider,
        onRefresh: refreshMoreProvider.isRefreshAnimation ? null : onRefresh,
        child: LoadMore(
          refreshMoreProvider: refreshMoreProvider,
          onMore: onMore,
          child: child,
        ));
  }
}
