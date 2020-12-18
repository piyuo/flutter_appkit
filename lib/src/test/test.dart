import 'package:flutter/widgets.dart';

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
