import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/identifier.dart' as identifier;
import 'package:libcli/memory_cache.dart' as cache;
import 'package:libcli/pb/pb.dart' as pb;
import 'firewall.dart';

void main() {
  setUp(() async {
    cacheDuration = const Duration(seconds: 1);
  });

  group('[command-firewall]', () {
    test('should pass firewall', () async {
      final cmd = pb.Error()..code = "pass-" + identifier.randomNumber(5);
      final response = firewallBegin(cmd.jsonString);
      expect(response is FirewallPass, true);
    });

    test('should block IN_FLIGHT', () async {
      final cmd = pb.Error()..code = "flight-" + identifier.randomNumber(5);
      final cmd2 = pb.Error()..code = "not-flight-" + identifier.randomNumber(5);
      expect(firewallBegin(cmd.jsonString) is FirewallPass, true);
      expect(firewallBegin(cmd.jsonString) is FirewallBlock, true); // check again
      expect(firewallBegin(cmd2.jsonString) is FirewallPass, true); // other command will pass
      firewallEnd(cmd.jsonString, pb.Error()); // set complete
      expect(firewallBegin(cmd.jsonString) is FirewallBlock, false);
    });

    test('should get response from cache', () async {
      final cmd = pb.Error()..code = "cache-" + identifier.randomNumber(5);
      expect(firewallBegin(cmd.jsonString) is FirewallPass, true);
      firewallEnd(cmd.jsonString, pb.Error()..code = 'hi');
      final response = firewallBegin(cmd.jsonString);
      expect(response is pb.Error, true);
      if (response is pb.Error) {
        expect(response.code, 'hi');
      }
      await Future.delayed(const Duration(milliseconds: 1001)); // expire the cache
      expect(firewallBegin(cmd.jsonString) is FirewallPass, true);
    });

    test('should block when command overflow', () async {
      maxAllowPostDuration = const Duration(milliseconds: 900);
      for (int i = 0; i < maxAllowPostCount; i++) {
        final cmdID = "not-overflow-" + identifier.randomNumber(5);
        final cmd = pb.Error()..code = cmdID;
        firewallBegin(cmd.jsonString) is FirewallPass;
        firewallEnd(cmd.jsonString, pb.Error()); // set complete
      }
      final countBeforeExpire = cache.length;
      expect(countBeforeExpire >= maxAllowPostCount, true);
      final cmdID2 = "overflow-" + identifier.randomNumber(5);
      final cmd2 = pb.Error()..code = cmdID2;
      expect(firewallBegin(cmd2.jsonString) is FirewallBlock, true);
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin(cmd2.jsonString) is FirewallPass, true);
    });

    test('should block when server request BLOCK_SHORT', () async {
      // set block short to 0.5s
      blockShortDuration = const Duration(milliseconds: 500);

      expect(firewallBegin('short') is FirewallPass, true);

      // server request block short duration
      firewallEnd('short', pb.Error()..code = blockShort); // set complete
      var result = firewallBegin('short');
      expect(result is FirewallBlock, true);
      expect((result as FirewallBlock).reason, blockShort);

      //try again, still block
      expect(firewallBegin('short') is FirewallBlock, true);

      // wait 1 seconds should pass short duration
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin('short') is FirewallPass, true);
    });

    test('should block when server request BLOCK_LONG', () async {
      // set block short to 0.5s
      blockLongDuration = const Duration(milliseconds: 500);

      expect(firewallBegin('long') is FirewallPass, true);

      // server request block long duration
      firewallEnd('long', pb.Error()..code = blockLong); // set complete
      var result = firewallBegin('long');
      expect(result is FirewallBlock, true);
      expect((result as FirewallBlock).reason, blockLong);

      //try again, still block
      expect(firewallBegin('long') is FirewallBlock, true);

      // wait 1 seconds should pass short duration
      await Future.delayed(const Duration(seconds: 1));
      expect(firewallBegin('long') is FirewallPass, true);
    });
  });
}
