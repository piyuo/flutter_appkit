import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as widgets;

/// Context used for mock BuildContext
///
class Context extends Mock implements widgets.BuildContext {}

/// useTestFont set text scale to 1/2, cause font in flutter test is bigger than real device, need scale down
///
///     testing.useTestFont(tester);
///
void useTestFont(WidgetTester tester) {
  tester.binding.window.textScaleFactorTestValue = 0.5; // test font is bigger than real device, need scale down
}
