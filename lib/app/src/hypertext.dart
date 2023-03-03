import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/assets/assets.dart' as asset;
import 'package:libcli/util/util.dart' as util;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'loading_screen.dart';

/// Span is a part of Hypertext
class Span {
  const Span({
    required this.text,
    this.textStyle,
  });

  /// text to show
  final String text;

  /// textStyle is the text style of normal text
  final TextStyle? textStyle;

  TextSpan build(BuildContext context) {
    return TextSpan(
      text: text,
      style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
    );
  }
}

/// Span is a part of Hypertext
class Bold extends Span {
  const Bold({
    required String text,
    TextStyle? textStyle,
  }) : super(text: text, textStyle: textStyle);

  @override
  TextSpan build(BuildContext context) {
    return TextSpan(
      text: text,
      style: textStyle ?? Theme.of(context).textTheme.titleMedium,
    );
  }
}

/// Link is a part of Hypertext, it can be clicked
class Link extends Span {
  const Link({
    required String text,
    required this.onPressed,
    TextStyle? textStyle,
  }) : super(text: text, textStyle: textStyle);

  /// onTap callback
  final void Function(BuildContext context, TapUpDetails details) onPressed;

  @override
  TextSpan build(BuildContext context) {
    //if InkSplash not show animation, properly because parent Container set background color
    TapGestureRecognizer? recognizer;
    recognizer = TapGestureRecognizer()..onTapUp = (TapUpDetails details) => onPressed(context, details);
    return TextSpan(
      text: text,
      recognizer: recognizer,
      style: textStyle ?? const TextStyle(color: Colors.blue),
    );
  }
}

/// Url is a part of Hypertext, it can be clicked and open url
class Url extends Link {
  Url({
    required String text,
    this.url,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          onPressed: (_, __) {
            var openUrl = url ?? text;
            if (!openUrl.startsWith('http')) {
              openUrl = 'http://$openUrl';
            }
            util.openUrl(openUrl);
          },
        );

  /// url is the url to open
  final String? url;
}

/// PopText is a part of Hypertext, it can be clicked and show popup text content
class PopText extends Link {
  PopText({
    required String text,
    required this.content,
    this.popupSize = const Size(240, 180),
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          onPressed: (context, details) => dialog.showMoreText(
            context,
            text: content,
            targetRect: Rect.fromLTWH(details.globalPosition.dx, details.globalPosition.dy, 0, 15),
            size: popupSize,
          ),
        );

  /// content is text content to show
  final String content;

  /// popupSize is the size of popup window
  final Size popupSize;
}

/// DocumentLink is a part of Hypertext, it can be clicked and show document content
class DocumentLink extends Link {
  DocumentLink({
    required String text,
    required this.docName,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          onPressed: (context, details) => delta.pushRoute(context, DocumentViewer(docName: docName, title: text)),
        );

  /// docPath document path
  final String docName;
}

/// Hypertext is a widget to show text with bold and link
class Hypertext extends StatelessWidget {
  const Hypertext({
    Key? key,
    this.children = const [],
  }) : super(key: key);

  /// children is a list of Span
  final List<Span> children;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: children.map((Span span) => span.build(context)).toList(),
      ),
    );
  }
}

/// DocumentViewer show document from asset
class DocumentViewer extends StatelessWidget {
  const DocumentViewer({
    required this.docName,
    this.title = '',
    Key? key,
  }) : super(key: key);

  final String title;

  final String docName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_DocumentViewerProvider>(
        create: (context) => _DocumentViewerProvider(
              docName: docName,
              title: title,
            ),
        child: Consumer<_DocumentViewerProvider>(
            builder: (context, docProvider, child) => LoadingScreen(
                  future: () async => await docProvider.load(),
                  builder: () => Scaffold(
                      appBar: AppBar(
                        title: Text(docProvider.title),
                      ),
                      body: SafeArea(
                        right: false,
                        bottom: true,
                        child: Padding(padding: const EdgeInsets.all(10), child: Markdown(data: docProvider.md)),
                      )),
                )));
  }
}

/// _DocumentViewerProvider load doc from asset
class _DocumentViewerProvider with ChangeNotifier {
  _DocumentViewerProvider({
    required this.docName,
    required this.title,
  });

  /// title is doc title
  final String title;

  /// docName is doc name
  final String docName;

  /// md is markdown content
  String md = '';

  Future<void> load() async {
    md = await asset.loadString(
      assetName: 'docs/${docName}_${i18n.localeKey}.md',
    );
    notifyListeners();
  }
}



/*
    recognizer = TapGestureRecognizer()
      ..onTapCancel = state._handleTapCancel
      ..onTapUp = (TapUpDetails details) {
        state._handleTap();
        onPressed();
      }
      ..onTap = () {}
      ..onTapDown = state._handleTapDown;

class HyperTextState extends State<Hypertext> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RichText(
      text: TextSpan(
        children: widget.children.map((Span span) => span.build(context, this)).toList(),
      ),
    );
  }
}

final Set<InkSplash?> _splashes = HashSet<InkSplash?>();

  /// _currentSplash is the current splash
  InkSplash? _currentSplash;

  /// splash is the current splash
  InkSplash? splash;

  void _handleTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    splash = InkSplash(
        controller: Material.of(context),
        textDirection: TextDirection.ltr,
        containedInkWell: true,
        referenceBox: referenceBox,
        position: referenceBox.globalToLocal(details.globalPosition),
        color: Theme.of(context).splashColor,
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
  bool get wantKeepAlive => (_splashes.isNotEmpty);

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





*/