import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:libcli/src/dialogs/dialogs.dart' as dialogs;
import 'package:libcli/src/widgets/page-route.dart';
import 'package:libcli/src/widgets/hypertext/doc_page.dart';

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
  final bool bold;

  final String text;

  final void Function(BuildContext)? onTap;

  final void Function(BuildContext, TapUpDetails)? onTapUp;

  _Span(
    this.text, {
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
        Navigator.of(context).push(
          safeTestMaterialRoute(
            DocPage(docName: docName, title: text),
          ),
        );
      },
    );
  }

  void tip(
    String text,
    String tip, {
    double width = 240,
    double height = 180,
  }) {
    return link(
      text,
      onTapUp: (BuildContext context, TapUpDetails details) => dialogs.tooltip(
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
    Function(BuildContext)? onTap,
    Function(BuildContext, TapUpDetails)? onTapUp,
  }) {
    if (!children.isEmpty) {
      children.add(_Span(" "));
    }
    children.add(_Span(
      text,
      onTap: onTap,
      onTapUp: onTapUp,
    ));
    children.add(_Span(" "));
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
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var bColor = isDark ? Colors.white : Colors.black;
    var linkColor = isDark ? Colors.lightBlue[300]! : Colors.lightBlue[800]!;
    return RichText(
      text: TextSpan(
        children: widget.children.map((_Span span) {
          var textColor = widget.color ?? Color.fromRGBO(134, 134, 139, 1);
          var boldColor = widget.boldColor ?? bColor;
          var color = span.bold == true ? boldColor : textColor;
          var recognizer = null;
          if (span.onTap != null || span.onTapUp != null) {
            color = widget.linkColor ?? linkColor;
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
              fontSize: 16,
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
