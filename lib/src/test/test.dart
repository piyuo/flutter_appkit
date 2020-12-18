import 'package:flutter/widgets.dart';
import 'package:mockito/mockito.dart';

/// MockBuildContext used for mock BuildContext
///
class MockBuildContext extends Mock implements BuildContext {}

/// MockNavigatorObserver used for mock NavigatorObserver
///
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

/// findStringInRichText return true if find contain string in rich text widget
///
bool findStringInRichText(final Widget widget, String contain) {
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
