import 'package:flutter/material.dart';

/// SliverScaffold create scaffold with sliver appbar and sliver body
class SliverScaffold extends StatelessWidget {
  const SliverScaffold({
    required this.children,
    this.backgroundColor,
    this.appBar,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  final Color? backgroundColor;

  final SliverAppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            if (appBar != null) appBar!,
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
                childCount: 1,
              ),
            ),
          ],
        ));
  }
}
