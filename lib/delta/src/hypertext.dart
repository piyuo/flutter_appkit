import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:libcli/util.dart' as util;

/// _testMode true should return success, false return error, otherwise behave normal
///
bool testMode = false;

// testModeAlwaySuccess will let every function success
//
void testModeAlwaySuccess() {
  testMode = true;
}

// TestModeBackNormal stop test mode and back to normal
//
void testModeBackNormal() {
  testMode = false;
}

class _Span {
  _Span(
    this.text, {
    this.onTap,
    this.bold = false,
  });

  final bool bold;

  final String text;

  final void Function(BuildContext, TapUpDetails)? onTap;
}

class Hypertext extends StatefulWidget {
  final List<_Span> children = [];

  final Color? color;

  final Color? boldColor;

  final Color? linkColor;

  final double? fontSize;

  Hypertext({
    Key? key,
    this.color,
    this.boldColor,
    this.linkColor,
    this.fontSize = 16,
  }) : super(key: key);

  void span(String text) {
    children.add(_Span(text));
  }

  void bold(String text) {
    children.add(_Span(text, bold: true));
  }

  void link(
    String text, {
    String? url,
  }) {
    url = url ?? text;
    return action(
      text,
      onTap: (_, __) {
        if (!url!.startsWith('http')) {
          url = 'http://' + url!;
        }
        util.openUrl(url!);
      },
    );
  }

  void action(
    String text, {
    Function(BuildContext, TapUpDetails)? onTap,
  }) {
    if (children.isNotEmpty) {
      children.add(_Span(" "));
    }
    children.add(_Span(
      text,
      onTap: onTap,
    ));
    children.add(_Span(" "));
  }

  @override
  HyperTextState createState() => HyperTextState();
}

class HyperTextState extends State<Hypertext> with AutomaticKeepAliveClientMixin {
  final Set<InkSplash?> _splashes = HashSet<InkSplash?>();

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
        position: referenceBox.globalToLocal(details.globalPosition),
        color: theme.splashColor,
        onRemoved: () {
          assert(_splashes.contains(splash));
          _splashes.remove(splash);
          if (_currentSplash == splash) _currentSplash = null;
          updateKeepAlive();
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
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var bColor = isDark ? Colors.white : Colors.black;
    var linkColor = isDark ? Colors.lightBlue[300]! : Colors.lightBlue[800]!;
    return RichText(
      text: TextSpan(
        children: widget.children.map((_Span span) {
          var textColor = widget.color ?? const Color.fromRGBO(134, 134, 139, 1);
          var boldColor = widget.boldColor ?? bColor;
          var color = span.bold == true ? boldColor : textColor;
          TapGestureRecognizer? recognizer;
          if (span.onTap != null) {
            color = widget.linkColor ?? linkColor;
            recognizer = TapGestureRecognizer()
              ..onTapCancel = _handleTapCancel
              ..onTapUp = (TapUpDetails details) {
                _handleTap();
                if (span.onTap != null) {
                  span.onTap!(context, details);
                }
              }
              ..onTap = () {}
              ..onTapDown = _handleTapDown;
          }
          return TextSpan(
            text: span.text,
            recognizer: recognizer,
            style: TextStyle(
              fontSize: widget.fontSize,
              decoration: span.onTap != null ? TextDecoration.underline : null,
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
