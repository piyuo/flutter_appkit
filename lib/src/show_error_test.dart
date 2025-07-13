// ===============================================
// Test Suite: show_error_test.dart
// Description: Widget tests for error dialog functionality
//
// Test Groups:
//   - Setup and Teardown
//   - Dialog Display Tests
//   - Dialog Content Tests
//   - Dialog Actions Tests
//   - Error Message Tests
//   - Localization Tests
//   - Integration Tests
// ===============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/l10n/localization.dart';

import 'global_context.dart';
import 'show_error.dart';

void main() {
  group('showError', () {
    late Widget testApp;

    setUp(() {
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('displays error dialog with correct structure', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error message');

      // Show the error dialog
      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Verify title structure
      expect(find.byIcon(CupertinoIcons.exclamationmark_triangle_fill), findsOneWidget);
      expect(find.text('Oops, something went wrong'), findsOneWidget);

      // Verify content
      expect(find.text('An unexpected error occurred. We\'ve already logged this error. Please try again later.'),
          findsOneWidget);
      expect(find.text('Exception: Test error message'), findsOneWidget);

      // Verify action button
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(CupertinoDialogAction), findsOneWidget);
    });

    testWidgets('displays correct icon with destructive red color', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the icon widget and verify its properties
      final iconFinder = find.byIcon(CupertinoIcons.exclamationmark_triangle_fill);
      expect(iconFinder, findsOneWidget);

      final Icon iconWidget = tester.widget(iconFinder);
      expect(iconWidget.color, CupertinoColors.destructiveRed);
      expect(iconWidget.size, 48.0);
    });

    testWidgets('displays error message with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Custom error message');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the error message text
      final errorTextFinder = find.text('Exception: Custom error message');
      expect(errorTextFinder, findsOneWidget);

      // Verify the text styling
      final Text errorTextWidget = tester.widget(errorTextFinder);
      expect(errorTextWidget.style?.color, CupertinoColors.systemGrey);
    });

    testWidgets('close button dismisses dialog', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is present
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Tap close button
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });

    testWidgets('handles different error types correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Test with different error types
      final testCases = [
        'String error message',
        Exception('Exception error'),
        Error(),
        42, // Number as error
        null, // Null error
      ];

      for (final error in testCases) {
        showError(error, StackTrace.current);
        await tester.pumpAndSettle();

        // Verify dialog appears
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);

        // Verify error message is displayed (converted to string)
        expect(find.textContaining(error.toString()), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        // Verify dialog is dismissed
        expect(find.byType(CupertinoAlertDialog), findsNothing);
      }
    });

    testWidgets('dialog action button has correct properties', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the dialog action
      final actionFinder = find.byType(CupertinoDialogAction);
      expect(actionFinder, findsOneWidget);

      final CupertinoDialogAction actionWidget = tester.widget(actionFinder);
      expect(actionWidget.isDefaultAction, true);
      expect(actionWidget.isDestructiveAction, true);
      expect(actionWidget.child, isA<Text>());
    });

    testWidgets('title row layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the title row
      final rowFinder = find.descendant(
        of: find.byType(CupertinoAlertDialog),
        matching: find.byType(Row),
      );
      expect(rowFinder, findsAtLeastNWidgets(1));

      // Check that the row contains both icon and text
      final iconInRow = find.descendant(
        of: rowFinder.first,
        matching: find.byIcon(CupertinoIcons.exclamationmark_triangle_fill),
      );
      final textInRow = find.descendant(
        of: rowFinder.first,
        matching: find.text('Oops, something went wrong'),
      );

      expect(iconInRow, findsOneWidget);
      expect(textInRow, findsOneWidget);
    });

    testWidgets('content column layout is correct', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Find the content column
      final columnFinder = find.descendant(
        of: find.byType(CupertinoAlertDialog),
        matching: find.byType(Column),
      );
      expect(columnFinder, findsAtLeastNWidgets(1));

      // Check for the SizedBox spacing with height 10
      final sizedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.height == 10.0,
      );
      expect(sizedBoxFinder, findsOneWidget);
    });

    testWidgets('handles stack trace parameter correctly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');
      final testStack = StackTrace.current;

      // Test with stack trace
      showError(testError, testStack);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Test with null stack trace
      showError(testError, null);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('function is async and completes properly', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');
      bool functionCompleted = false;

      // Call showError and track completion
      showError(testError, StackTrace.current).then((_) {
        functionCompleted = true;
      });

      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Function should not have completed yet (dialog is still open)
      expect(functionCompleted, false);

      // Close the dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Now function should have completed
      expect(functionCompleted, true);
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });
  });

  group('showError localization', () {
    testWidgets('displays localized text correctly', (WidgetTester tester) async {
      final testApp = CupertinoApp(
        locale: const Locale('en', 'US'),
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify English localization
      expect(find.text('Oops, something went wrong'), findsOneWidget);
      expect(find.text('An unexpected error occurred. We\'ve already logged this error. Please try again later.'),
          findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });
  });

  group('showError edge cases', () {
    testWidgets('handles empty error message', (WidgetTester tester) async {
      final testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should still display dialog with empty exception
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: '), findsOneWidget);
    });

    testWidgets('handles very long error message', (WidgetTester tester) async {
      final testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final longMessage =
          'This is a very long error message that should still be displayed correctly in the dialog even though it might wrap to multiple lines and take up more space in the content area of the alert dialog.';
      final testError = Exception(longMessage);

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should still display dialog with long message
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.textContaining(longMessage), findsOneWidget);
    });
  });

  group('showError dialog prevention', () {
    late Widget testApp;

    setUp(() {
      testApp = CupertinoApp(
        localizationsDelegates: Localization.localizationsDelegates,
        supportedLocales: Localization.supportedLocales,
        home: GlobalContext(
          child: const Scaffold(
            body: Center(
              child: Text('Test App'),
            ),
          ),
        ),
      );
    });

    testWidgets('prevents multiple dialogs from showing simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final firstError = Exception('First error');
      final secondError = Exception('Second error');

      // Show first error dialog
      showError(firstError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify first dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Try to show second error dialog while first is still open
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should still only have one dialog (the first one)
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);
      expect(find.text('Exception: Second error'), findsNothing);

      // Close the first dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Now no dialogs should be showing
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });

    testWidgets('allows new dialog after previous one is closed', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final firstError = Exception('First error');
      final secondError = Exception('Second error');

      // Show first error dialog
      showError(firstError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify first dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: First error'), findsOneWidget);

      // Close the first dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify no dialogs are showing
      expect(find.byType(CupertinoAlertDialog), findsNothing);

      // Now show second error dialog
      showError(secondError, StackTrace.current);
      await tester.pumpAndSettle();

      // Should show the second dialog now
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: Second error'), findsOneWidget);
      expect(find.text('Exception: First error'), findsNothing);
    });

    testWidgets('showError returns immediately when dialog is already showing', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final firstError = Exception('First error');
      final secondError = Exception('Second error');

      bool firstCallCompleted = false;
      bool secondCallCompleted = false;

      // Start first showError call
      showError(firstError, StackTrace.current).then((_) {
        firstCallCompleted = true;
      });

      await tester.pumpAndSettle();

      // Verify first dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(firstCallCompleted, false); // Should not complete yet

      // Start second showError call while first dialog is still open
      showError(secondError, StackTrace.current).then((_) {
        secondCallCompleted = true;
      });

      await tester.pumpAndSettle();

      // Second call should complete immediately since it returns early
      expect(secondCallCompleted, true);
      expect(firstCallCompleted, false); // First call still waiting

      // Close the first dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Now first call should complete
      expect(firstCallCompleted, true);
      expect(find.byType(CupertinoAlertDialog), findsNothing);
    });

    testWidgets('multiple rapid calls only show one dialog', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final errors = [
        Exception('Error 1'),
        Exception('Error 2'),
        Exception('Error 3'),
        Exception('Error 4'),
      ];

      // Make multiple rapid calls
      for (final error in errors) {
        showError(error, StackTrace.current);
      }

      await tester.pumpAndSettle();

      // Should only show one dialog (the first one)
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Exception: Error 1'), findsOneWidget);

      // Verify other errors are not shown
      expect(find.text('Exception: Error 2'), findsNothing);
      expect(find.text('Exception: Error 3'), findsNothing);
      expect(find.text('Exception: Error 4'), findsNothing);
    });

    testWidgets('dialog has correct route settings name', (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final testError = Exception('Test error');

      showError(testError, StackTrace.current);
      await tester.pumpAndSettle();

      // Verify dialog is displayed
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);

      // Check that the dialog route has the correct name
      final BuildContext context = tester.element(find.byType(CupertinoAlertDialog));
      final ModalRoute? route = ModalRoute.of(context);
      expect(route?.settings.name, 'error_dialog');
    });
  });
}
