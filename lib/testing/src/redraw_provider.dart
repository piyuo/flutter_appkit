import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// RedrawProvider provide a way to redraw widget tree
class RedrawProvider with ChangeNotifier {
  void redraw() {
    notifyListeners();
  }

  /// of get RedrawProvider from context
  static RedrawProvider of(BuildContext context) {
    return Provider.of<RedrawProvider>(context, listen: false);
  }
}

/// provideRedraw provide a RedrawProvider to widget tree
Widget provideRedraw(Widget Function(RedrawProvider redrawProvider) builder) {
  return ChangeNotifierProvider<RedrawProvider>(
    create: (context) => RedrawProvider(),
    child: Consumer<RedrawProvider>(builder: (context, redrawProvider, _) => builder(redrawProvider)),
  );
}
