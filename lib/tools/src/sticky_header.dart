import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/// StickyHeader show show sticky header in a sliver list, act as group header
/// ```dart
/// StickyHeader(
///    headerBuilder: () => Container(
///    height: 60.0,
///    color: Colors.lightBlue,
///    padding: const EdgeInsets.symmetric(horizontal: 16.0),
///    alignment: Alignment.centerLeft,
///    child: const Text('Header #0', style: TextStyle(color: Colors.white)),
/// ),
/// builder: () => SliverList(
///   delegate: SliverChildBuilderDelegate(
///      (context, i) => ListTile(
///        leading: const CircleAvatar(child: Text('0')),
///        title: Text('List tile #$i'),
///      ),
///      childCount: 4,
///    ),
///  ),
/// ),
/// ```
class StickyHeader extends StatelessWidget {
  const StickyHeader({
    required this.headerBuilder,
    required this.builder,
    Key? key,
  }) : super(key: key);

  /// headerBuilder is the builder for the sticky header
  final Widget Function() headerBuilder;

  /// builder is the builder for the sliver list
  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader.builder(
      builder: (_, __) => headerBuilder(),
      sliver: builder(),
    );
  }
}
