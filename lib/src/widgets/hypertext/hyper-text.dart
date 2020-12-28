import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/src/widgets/hypertext/doc_page.dart';

class _Span {
  final Key? key;

  final bool bold;

  final String text;

  final void Function(BuildContext)? onTap;

  final void Function(BuildContext, TapUpDetails)? onTapUp;

  _Span(
    this.text, {
    this.key,
    this.onTap,
    this.onTapUp,
    this.bold = false,
  });
}

class HyperText extends StatefulWidget {
  final List<_Span> children = [];

  final Color? color;

  final Color? boldColor;

  final Color? linkColor;

  HyperText({
    this.color,
    this.boldColor,
    this.linkColor,
  });

  void span(String text) {
    children.add(_Span(text));
  }

  void bold(String text) {
    children.add(_Span(text, bold: true));
  }

  void doc(String text, String docName) {
    return link(
      text,
      onTap: (BuildContext context) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return DocPage(docName: docName, title: text);
        }));
      },
    );
  }

  void tip(
    String text,
    String tip, {
    double width = 180,
    double height = 120,
  }) {
    return link(
      text,
      onTapUp: (BuildContext context, TapUpDetails details) => tooltip(
        context,
        tip,
        widgetPosition: details.globalPosition,
        width: width,
        height: height,
      ),
    );
  }

  void link(
    String text, {
    Key? key,
    Function(BuildContext)? onTap,
    Function(BuildContext, TapUpDetails)? onTapUp,
  }) {
    children.add(_Span(
      text,
      key: key,
      onTap: onTap,
      onTapUp: onTapUp,
    ));
  }

  @override
  HyperTextState createState() => HyperTextState();
}

class HyperTextState extends State<HyperText> with AutomaticKeepAliveClientMixin {
  Set<InkSplash?> _splashes = HashSet<InkSplash?>();

  InkSplash? _currentSplash;

  InkSplash? splash;

  @override
  bool get wantKeepAlive => (_splashes.isNotEmpty);

  //if InkSplash not show animation, properly because parent Container set background color
  void _handleTapDown(TapDownDetails details) {
    var theme = Theme.of(context);
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    splash = InkSplash(
        controller: Material.of(context) as MaterialInkController,
        textDirection: TextDirection.ltr,
        containedInkWell: true,
        referenceBox: referenceBox,
        //rectCallback: () => referenceBox.paintBounds,
        position: referenceBox.globalToLocal(details.globalPosition),
        //position: details.globalPosition,
        //position: Offset.zero,
        color: theme.splashColor,
        onRemoved: () {
          assert(_splashes.contains(splash));
          _splashes.remove(splash);
          if (_currentSplash == splash) _currentSplash = null;
          updateKeepAlive();
          // else we're probably in deactivate()
        });
    _splashes.add(splash);
    _currentSplash = splash;
    updateKeepAlive();
  }

  void _handleTap() {
    _currentSplash?.confirm();
    _currentSplash = null;
    Feedback.forTap(context);
  }

  void _handleTapCancel() {
    _currentSplash?.cancel();
    _currentSplash = null;
  }

  @override
  void deactivate() {
    final Set<InkSplash?> splashes = _splashes;
    _splashes.clear();
    for (InkSplash? splash in splashes) {
      if (splash != null) {
        splash.dispose();
      }
    }
    _currentSplash = null;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RichText(
      text: TextSpan(
        children: widget.children.map((_Span span) {
          var textColor = widget.color ?? Color.fromRGBO(134, 134, 139, 1);
          var boldColor = widget.boldColor ?? Color.fromRGBO(245, 99, 0, 1);
          var color = span.bold == true ? boldColor : textColor;
          var recognizer = null;
          if (span.onTap != null || span.onTapUp != null) {
            color = widget.linkColor ?? Color.fromRGBO(0, 102, 204, 1);
            recognizer = TapGestureRecognizer()
              ..onTapCancel = _handleTapCancel
              ..onTapUp = (TapUpDetails details) {
                if (span.onTapUp != null) {
                  span.onTapUp!(context, details);
                }
              }
              ..onTapDown = _handleTapDown
              ..onTap = () {
                _handleTap();
                if (span.onTap != null) {
                  span.onTap!(context);
                }
              };
          }
          return TextSpan(
            text: span.text,
            recognizer: recognizer,
            style: TextStyle(
              decoration: span.onTap != null || span.onTapUp != null ? TextDecoration.underline : null,
              color: color,
              fontWeight: span.bold == true ? FontWeight.w600 : FontWeight.normal,
              height: 1.6,
            ),
          );
        }).toList(),
      ),
    );
  }
}
