import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

/// TransformContainerBuilder
typedef TransformContainerBuilder = Widget Function(
  BuildContext context,
  VoidCallback action,
);

/// TransformContainer is the container transform pattern is designed for transitions between UI elements that include a container
/// ```dart
/// TransformContainer(
/// closedBuilder: (_, openContainer) {
///   return OutlinedButton(
///     onPressed: openContainer,
///     child: const Icon(Icons.add, color: Colors.white),
///   );
/// },
/// closedColor: Colors.blue,
/// openBuilder: (_, closeContainer) {
///   return Container();
/// })
/// ```
class TransformContainer extends StatelessWidget {
  /// TransformContainer is the container transform pattern is designed for transitions between UI elements that include a container
  /// ```dart
  /// TransformContainer(
  /// closedBuilder: (_, openContainer) {
  ///   return OutlinedButton(
  ///     onPressed: openContainer,
  ///     child: const Icon(Icons.add, color: Colors.white),
  ///   );
  /// },
  /// closedColor: Colors.blue,
  /// openBuilder: (_, closeContainer) {
  ///   return Container();
  /// })
  /// ```
  const TransformContainer({
    required this.closedBuilder,
    required this.openBuilder,
    this.closedColor = Colors.white,
    this.openColor = Colors.white,
    Key? key,
  }) : super(key: key);

  /// closedBuilder is the builder for the closed state
  final TransformContainerBuilder closedBuilder;

  /// closedColor is color for the closed state
  final Color closedColor;

  /// openBuilder is the builder for the open state
  final TransformContainerBuilder openBuilder;

  /// openColor is color for the open state
  final Color openColor;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      transitionDuration: const Duration(milliseconds: 800),
      closedBuilder: closedBuilder,
      openColor: openColor,
      closedColor: closedColor,
      openBuilder: openBuilder,
    );
  }
}
