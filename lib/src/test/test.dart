import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/// MockBuildContext used for mock BuildContext
///
class MockBuildContext extends Mock implements BuildContext {}

/// MockNavigatorObserver used for mock NavigatorObserver
///
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// containInRichText return true if find contain string in rich text widget
///
bool containInRichText(final Widget widget, String contain) {
  if (widget is RichText) {
    if (widget.text is TextSpan) {
      final buffer = StringBuffer();
      (widget.text as TextSpan).computeToPlainText(buffer);
      var str = buffer.toString();
      return str.contains(contain);
    }
  }
  return false;
}

bool _findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan &&
      visitor.text != null &&
      visitor.text!.toLowerCase().trim() == text.toLowerCase().trim() &&
      visitor.recognizer != null) {
    var x = visitor.recognizer as TapGestureRecognizer;
    if (x.onTap != null) {
      x.onTap!();
    }
    return false;
  }

  return true;
}

bool _tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => _findTextAndTap(visitor, text),
  );
  return isTapped;
}

/// RichTextSpanFinder find TextSpan in RichText to tap
///
///     await tester.tap(RichTextSpanFinder('Resend'));
///
Finder richTextSpanFinder(String text) {
  return find.byWidgetPredicate(
    (widget) => widget is RichText && _tapTextSpan(widget, text),
  );
}
