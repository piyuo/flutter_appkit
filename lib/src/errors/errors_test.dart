import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart';
import 'package:libcli/log.dart';
import 'package:libcli/dialogs.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/errors/errors.dart';
import 'package:libcli/command.dart';

void main() {
  final GlobalKey keyBtn = GlobalKey();

  setUp(() async {
    initGlobalTranslation('en', 'US');
  });

  Widget createSample({
    required void Function(BuildContext context) onPressed,
  }) {
    return CupertinoApp(
      navigatorKey: dialogsNavigatorKey,
      home: DialogOverlay(
        child: Builder(builder: (BuildContext ctx) {
          return CupertinoButton(
            key: keyBtn,
            child: Text('button'),
            onPressed: () => onPressed(ctx),
          );
        }),
      ),
    );
  }

  group('[errors]', () {
    testWidgets('should alert when catch exception', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) {
          watch(() => throw Exception('mock exception'));
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when no internet', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) {
          watch(() => throw SocketException('wifi off'));
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when service not available', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          var contract = InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return true;
          };
          await broadcast(context, contract);
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when internet blocked', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          var contract = InternetRequiredContract(url: 'http://mock');
          contract.isInternetConnected = () async {
            return true;
          };
          contract.isGoogleCloudFunctionAvailable = () async {
            return false;
          };
          await broadcast(context, contract);
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when internal server error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await broadcast(context, InternalServerErrorEvent());
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when server not ready', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await broadcast(context, ServerNotReadyEvent());
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when bad request', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await broadcast(context, BadRequestEvent());
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when client timeout', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          try {
            throw TimeoutException('client timeout');
          } catch (e) {
            await broadcast(context, RequestTimeoutContract(isServer: false, exception: e, url: 'http://mock'));
          }
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when deadline exceeded', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await broadcast(context, RequestTimeoutContract(isServer: true, url: 'http://mock'));
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should alert when disk error', (WidgetTester tester) async {
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() => throw DiskErrorException());
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    });

    testWidgets('should toast when network is slow', (WidgetTester tester) async {
      mockToast();
      await tester.pumpWidget(
        createSample(onPressed: (context) async {
          watch(() {});
          await broadcast(context, SlowNetworkEvent());
        }),
      );
      expect(find.byType(CupertinoButton), findsOneWidget);
      await tester.tap(find.byType(CupertinoButton));
      await tester.pumpAndSettle();
      await expectToastAndWaitDismiss(tester);
    });
  });
}
