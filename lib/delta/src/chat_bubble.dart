import 'package:flutter/material.dart';

const double _bubbleRadius = 16;

/// ChatBubble is a chat bubble widget
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.child,
    this.bubbleRadius = _bubbleRadius,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    super.key,
  });

  /// bubbleRadius is bubble radius
  final double bubbleRadius;

  /// isSender is sender or receiver
  final bool isSender;

  /// bubble color
  final Color color;

  /// tail is show tail
  final bool tail;

  /// chat bubble child
  final Widget child;

  /// padding is bubble padding
  final EdgeInsetsGeometry padding;

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        isSender
            ? const Expanded(
                child: SizedBox(
                  width: 5,
                ),
              )
            : Container(),
        Container(
          color: Colors.transparent,
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bubbleRadius),
                topRight: Radius.circular(bubbleRadius),
                bottomLeft: Radius.circular(tail
                    ? isSender
                        ? bubbleRadius
                        : 0
                    : _bubbleRadius),
                bottomRight: Radius.circular(tail
                    ? isSender
                        ? 0
                        : bubbleRadius
                    : _bubbleRadius),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: padding,
                      child: child,
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
