import 'dart:async';
import 'package:libcli/src/dialogs/toast.dart';
import 'package:libcli/src/dialogs/main.dart';
import 'package:flutter_test/flutter_test.dart';

/// mockToast set duration minimum
///
void mockToast() {
  ToastHideDuration = Duration(milliseconds: 700);
}

/// expectToastAndWaitDismiss expect toast and wait for dismiss
///
Future<void> expectToastAndWaitDismiss(WidgetTester tester) async {
  expect(find.byType(Toast), findsWidgets);
  await tester.pumpAndSettle(const Duration(milliseconds: 701));
}
