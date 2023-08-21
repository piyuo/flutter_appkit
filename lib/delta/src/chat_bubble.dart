import 'package:flutter/material.dart';

const double _bubbleRadius = 16;

/// ChatBubble is a chat bubble widget
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.child,
    this.bubbleRadius = _bubbleRadius,
    this.isSender = true,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
    this.maxWidth = 300,
    super.key,
  });

  /// bubbleRadius is bubble radius
  final double bubbleRadius;

  /// isSender is sender or receiver
  final bool isSender;

  /// color is bubble color
  final Color? color;

  /// chat bubble child
  final Widget child;

  /// padding is bubble padding
  final EdgeInsetsGeometry padding;

  /// maxWidth is bubble max width
  final double maxWidth;

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bubbleRadius),
                topRight: Radius.circular(bubbleRadius),
                bottomLeft: Radius.circular(isSender ? bubbleRadius : 0),
                bottomRight: Radius.circular(isSender ? 0 : bubbleRadius),
              ),
              child: Container(
                color: color,
                padding: padding,
                child: child,
              ),
            ),
          ),
        ));
  }
}

//MediaQuery.of(context).size.width * .8