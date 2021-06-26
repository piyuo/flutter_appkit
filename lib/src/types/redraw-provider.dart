import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// RedrawProvider control redraw
class RedrawProvider with ChangeNotifier {
  void redraw() {
    notifyListeners();
  }
}

/// requireRedraw set redraw provider/consumer
requireRedraw({required Widget Function(BuildContext, RedrawProvider, Widget?) builder}) {
  return ChangeNotifierProvider<RedrawProvider>(
      create: (context) => RedrawProvider(), child: Consumer<RedrawProvider>(builder: builder));
}
