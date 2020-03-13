import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/data/prefs.dart' as prefs;
import 'package:libcli/hook/events.dart';
import 'package:libcli/hook/contracts.dart';
import 'package:libcli/eventbus/event_bus.dart' as eventBus;
import 'package:libcli/eventbus/contract.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    latestContract = null;
    latestEvent = null;
  });

  group('[prefs_error]', () {
/*
    test('should retry on disk error and ok', () async {
      eventBus.listen<CDiskFullOrNoAccess>((contract) {
        contract.complete(true);
      });
      data.retryDiskError();
      await eventBus.mockDone();
      expect(eventBus.latestContract is CDiskFullOrNoAccess, true);
      expect(eventBus.latestEvent is ERefuseCleanDisk, false);
    });

    test('should retry error and user refuse will cause ERefuseCleanDisk',
        () async {
      eventBus.listen<CDiskFullOrNoAccess>((contract) {
        contract.complete(false);
      });
      data.retryDiskError();
      await eventBus.mockDone();
      expect(eventBus.latestContract is CDiskFullOrNoAccess, true);
      expect(eventBus.latestEvent is ERefuseCleanDisk, true);
    });

    test('should retry on shared_preferences has error', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const MethodChannel('plugins.flutter.io/shared_preferences')
          .setMockMethodCallHandler((MethodCall methodCall) async {
        if (methodCall.method == 'getAll') {
          return <String, dynamic>{}; // set initial values here if desired
        } else if (methodCall.method == 'setBool') {

        }
        return null;
      });

      eventBus.listen<CDiskFullOrNoAccess>((contract) {
        contract.complete(false);
      });
      data.setBool('k', true);
      await eventBus.mockDone();
      expect(eventBus.latestContract is CDiskFullOrNoAccess, true);
      expect(eventBus.latestEvent is ERefuseCleanDisk, true);
    });*/
  });
}
