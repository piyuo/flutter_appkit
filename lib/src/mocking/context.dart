import 'package:flutter/widgets.dart' as widgets;
import 'package:mockito/mockito.dart';

/// Context used for mock BuildContext
///
class Context extends Mock implements widgets.BuildContext {}

/*
old code, need remove
extension MockContext on WidgetTester {
  /// inWidget let you run test function inside widget and get build  context
  ///
  ///     await tester.inWidget((ctx) {});
  ///
  inWidget(Function(BuildContext) test) async {
    await this.pumpWidget(
      Builder(
        builder: (BuildContext ctx) {
          test(ctx);
          return Placeholder();
        },
      ),
    );
  }

  /// inWidget let you run test function inside widget and get build  context
  ///
  ///     await tester.inWidget((ctx) {});
  ///
  mockContext() async {
    var context;
    await this.inWidget((ctx) async {
      context = ctx;
    });
    return context;
  }
}

*/
