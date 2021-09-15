import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/command.dart' as command;
import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/log.dart' as log;
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/testing.dart' as testing;
import 'package:libcli/src/error/error.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    showCatchedAlert = false;
  });

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return MaterialApp(
      navigatorKey: dialog.navigatorKey,
      builder: dialog.init(),
      home: Builder(builder: (BuildContext ctx) {
        return TextButton(
          key: keyBtn,
          child: const Text('button'),
          onPressed: () => onPressed(ctx),
        );
      }),
    );
  }

  group('[error]', () {
    testWidgets('should alert when catch exception', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) {
          watch(() => throw Exception('mock exception'));
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when firewall block', (WidgetTester tester) async {
      testing.useTestFont(tester);
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.FirewallBlockEvent('BLOCK_SHORT'));
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when no internet', (WidgetTester tester) async {
      testing.useTestFont(tester);
      await tester.pumpWidget(
        createSample(onPressed: (context) {
          watch(() => throw const SocketException('wifi off'));
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when service not available', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          var contract = command.InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return true;
          };
          await eventbus.broadcast(context, contract);
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when internet blocked', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          var contract = command.InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return false;
          };
          await eventbus.broadcast(context, contract);
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when internal server error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.InternalServerErrorEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when server not ready', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.ServerNotReadyEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when bad request', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.BadRequestEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when client timeout', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          try {
            throw TimeoutException('client timeout');
          } catch (e) {
            await eventbus.broadcast(
                context, command.RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
          }
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when deadline exceeded', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.RequestTimeoutContract(isServer: true, url: 'http://mock'));
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should alert when disk error', (WidgetTester tester) async {
      tester.binding.window.textScaleFactorTestValue = 0.5; // test font is bigger than real device, need scale down
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() => throw log.DiskErrorException());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('should toast when network is slow', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await eventbus.broadcast(context, command.SlowNetworkEvent());
        }),
      );
      expect(find.byType(TextButton), findsOneWidget);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      await dialog.expectToast();
    });
  });
}
