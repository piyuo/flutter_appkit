// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/testing/testing.dart' as testing;
import 'error.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    showCatchedAlert = false;
  });

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return Builder(
        builder: (BuildContext context) => delta.GlobalContextSupport(
              child: MaterialApp(
                home: TextButton(
                  key: keyBtn,
                  child: const Text('button'),
                  onPressed: () => onPressed(context),
                ),
              ),
            ));
  }

  group('[error]', () {
    testWidgets('should alert when catch exception', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) {
          watch(() => throw Exception('mock exception'));
        }),
      );

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when firewall block', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.FirewallBlockEvent('BLOCK_SHORT'));
        }),
      );

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when no internet', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) {
          watch(() => throw const SocketException('wifi off'));
        }),
      );

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when service not available', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          var contract = command.InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return true;
          };
          await eventbus.broadcast(contract);
        }),
      );

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when internet blocked', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          var contract = command.InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return false;
          };
          await eventbus.broadcast(contract);
        }),
      );

      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when internal server error', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.InternalServerErrorEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when server not ready', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.ServerNotReadyEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when bad request', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.BadRequestEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when client timeout', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          try {
            throw TimeoutException('client timeout');
          } catch (e) {
            await eventbus.broadcast(command.RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
          }
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when deadline exceeded', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.RequestTimeoutContract(isServer: true, url: 'http://mock'));
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when disk error', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() => throw log.DiskErrorException());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should toast when network is slow', (WidgetTester tester) async {
      await testing.mockApp(
        tester,
        child: createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(command.SlowNetworkEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await dialog.expectToast();
    });
  });
}
