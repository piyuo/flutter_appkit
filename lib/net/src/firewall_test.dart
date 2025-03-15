// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/utils/utils.dart' as utils;

import 'firewall.dart';

void main() {
  setUp(() async {
    kCacheDuration = const Duration(seconds: 1);
  });

  group('[net.firewall]', () {
    test('should pass firewall', () async {
      final cmd = sample.Person(name: "pass-${utils.randomNumber(5)}");
      final response = firewallBegin(cmd);
      expect(response, true);
    });

    test('should block IN_FLIGHT', () async {
      final cmd = sample.Person(name: "flight-${utils.randomNumber(5)}");
      final cmd2 = sample.Person(name: "not-flight-${utils.randomNumber(5)}");
      expect(firewallBegin(cmd), isTrue);
      expect(firewallBegin(cmd), isFalse); // check again
      expect(firewallBegin(cmd2), isTrue); // other command will pass
      firewallEnd(cmd); // set complete
      expect(firewallBegin(cmd), isTrue);
    });

    test('should block when command overflow', () async {
      kMaxAllowPostDuration = const Duration(milliseconds: 900);
      for (int i = 0; i < kMaxAllowPostCount; i++) {
        final cmdID = "not-overflow-${utils.randomNumber(5)}";
        final cmd = sample.Person()..name = cmdID;
        firewallBegin(cmd);
        firewallEnd(cmd); // set complete
      }
      final countBeforeExpire = cache.length;
      expect(countBeforeExpire >= kMaxAllowPostCount, true);
      final cmdID2 = "overflow-${utils.randomNumber(5)}";
      final cmd2 = sample.Person()..name = cmdID2;
      expect(firewallBegin(cmd2), isFalse);
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(cmd2), isTrue);
    });
/*
    test('should block when server request BLOCK_SHORT', () async {
      // set block short to 0.5s
      blockShortDuration = const Duration(milliseconds: 500);
      final short = sample.Person()..name = "short";
      expect(firewallBegin(short) is FirewallPass, true);

      // server request block short duration
      firewallEnd(short, sample.Person()..name = blockShort); // set complete
      var result = firewallBegin(short);
      expect(result is FirewallBlock, true);
      expect((result as FirewallBlock).reason, blockShort);

      //try again, still block
      expect(firewallBegin(short) is FirewallBlock, true);

      // wait 1 seconds should pass short duration
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(short) is FirewallPass, true);
    });

    test('should block when server request BLOCK_LONG', () async {
      // set block short to 0.5s
      blockLongDuration = const Duration(milliseconds: 500);
      final long = sample.Person()..name = "long";
      expect(firewallBegin(long) is FirewallPass, true);

      // server request block long duration
      firewallEnd(long, sample.Person(name: blockLong)); // set complete
      var result = firewallBegin(long);
      expect(result is FirewallBlock, true);
      expect((result as FirewallBlock).reason, blockLong);

      //try again, still block
      expect(firewallBegin(long) is FirewallBlock, true);

      // wait 1 seconds should pass short duration
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(long) is FirewallPass, true);
    });
*/
  });
}
