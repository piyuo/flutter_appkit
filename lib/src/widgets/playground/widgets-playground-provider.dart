import 'package:flutter/widgets.dart';

class WidgetsPlaygroundProvider {
  final account = TextEditingController();

  final FocusNode focusEmail = FocusNode(debugLabel: 'email');

  WidgetsPlaygroundProvider() {}
}
