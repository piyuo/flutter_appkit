import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/cache/cache.dart' as cache;
import 'firewall.dart';
import 'package:libcli/common/common.dart' as common;

void main() {
  setUp(() async {
    cacheDuration = const Duration(seconds: 1);
  });

  group('[net.firewall]', () {
    test('should pass firewall', () async {
      final cmd = common.Error()..code = "pass-${utils.randomNumber(5)}";
      final response = firewallBegin(cmd);
      expect(response is FirewallPass, true);
    });

    test('should block IN_FLIGHT', () async {
      final cmd = common.Error()..code = "flight-${utils.randomNumber(5)}";
      final cmd2 = common.Error()..code = "not-flight-${utils.randomNumber(5)}";
      expect(firewallBegin(cmd) is FirewallPass, true);
      expect(firewallBegin(cmd) is FirewallBlock, true); // check again
      expect(firewallBegin(cmd2) is FirewallPass, true); // other command will pass
      firewallEnd(cmd, common.Error()); // set complete
      expect(firewallBegin(cmd) is FirewallBlock, false);
    });

    test('should get response from cache', () async {
      final cmd = common.Error()..code = "cache-${utils.randomNumber(5)}";
      expect(firewallBegin(cmd) is FirewallPass, true);
      firewallEnd(cmd, common.Error()..code = 'hi');
      final response = firewallBegin(cmd);
      expect(response is common.Error, true);
      if (response is common.Error) {
        expect(response.code, 'hi');
      }
      await Future.delayed(const Duration(milliseconds: 1001)); // expire the cache
      expect(firewallBegin(cmd) is FirewallPass, true);
    });

    test('should block when command overflow', () async {
      maxAllowPostDuration = const Duration(milliseconds: 900);
      for (int i = 0; i < maxAllowPostCount; i++) {
        final cmdID = "not-overflow-${utils.randomNumber(5)}";
        final cmd = common.Error()..code = cmdID;
        firewallBegin(cmd) is FirewallPass;
        firewallEnd(cmd, common.Error()); // set complete
      }
      final countBeforeExpire = cache.length;
      expect(countBeforeExpire >= maxAllowPostCount, true);
      final cmdID2 = "overflow-${utils.randomNumber(5)}";
      final cmd2 = common.Error()..code = cmdID2;
      expect(firewallBegin(cmd2) is FirewallBlock, true);
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(cmd2) is FirewallPass, true);
    });

    test('should block when server request BLOCK_SHORT', () async {
      // set block short to 0.5s
      blockShortDuration = const Duration(milliseconds: 500);
      final short = common.Error()..code = "short";
      expect(firewallBegin(short) is FirewallPass, true);

      // server request block short duration
      firewallEnd(short, common.Error()..code = blockShort); // set complete
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
      final long = common.Error()..code = "long";
      expect(firewallBegin(long) is FirewallPass, true);

      // server request block long duration
      firewallEnd(long, common.Error()..code = blockLong); // set complete
      var result = firewallBegin(long);
      expect(result is FirewallBlock, true);
      expect((result as FirewallBlock).reason, blockLong);

      //try again, still block
      expect(firewallBegin(long) is FirewallBlock, true);

      // wait 1 seconds should pass short duration
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(long) is FirewallPass, true);
    });
  });
}
