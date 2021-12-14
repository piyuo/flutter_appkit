import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:flutter_easyloading/src/widgets/container.dart';

/// expectToast expect toast exist
///
Future<void> expectToast() async {
  expect(find.byType(EasyLoadingContainer), findsOneWidget);
}

/// expectNoToast expect not toast
///
Future<void> expectNoToast() async {
  expect(find.byType(EasyLoadingContainer), findsNothing);
}
