import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/// StickyHeader show show sticky header in a sliver list, act as group header
class StickyHeader extends StatelessWidget {
  const StickyHeader({
    required this.headerBuilder,
    required this.sliverBuilder,
    Key? key,
  }) : super(key: key);

  final Widget Function() headerBuilder;

  final Widget Function() sliverBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverStickyHeader.builder(
      builder: (_, __) => headerBuilder(),
      sliver: sliverBuilder(),
    );
  }
}
