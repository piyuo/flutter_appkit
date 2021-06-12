import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/command/firewall.dart';
import 'package:libcli/identifier.dart' as identifier;
import 'package:libcli/cache.dart' as cache;
import 'package:libcli/pb.dart' as pb;

void main() {
  setUp(() async {
    CacheDuration = Duration(seconds: 1);
  });

  group('[command-firewall]', () {
    test('should pass firewall', () async {
      final cmd = pb.Error()..code = "pass-" + identifier.randomNumber(5);
      final response = firewall(cmd.jsonString);
      expect(response is FirewallPass, true);
    });

    test('should block IN_FLIGHT', () async {
      final cmd = pb.Error()..code = "flight-" + identifier.randomNumber(5);
      final cmd2 = pb.Error()..code = "not-flight-" + identifier.randomNumber(5);
      expect(firewall(cmd.jsonString) is FirewallPass, true);
      expect(firewall(cmd.jsonString) is FirewallBlock, true); // check again
      expect(firewall(cmd2.jsonString) is FirewallPass, true); // other command will pass
      firewallPostComplete(cmd.jsonString, pb.Error()); // set complete
      expect(firewall(cmd.jsonString) is FirewallBlock, false);
    });

    test('should get response from cache', () async {
      final cmd = pb.Error()..code = "cache-" + identifier.randomNumber(5);
      expect(firewall(cmd.jsonString) is FirewallPass, true);
      firewallPostComplete(cmd.jsonString, pb.Error()..code = 'hi');
      final response = firewall(cmd.jsonString);
      expect(response is pb.Error, true);
      if (response is pb.Error) {
        expect(response.code, 'hi');
      }
      await Future.delayed(Duration(milliseconds: 1001)); // expire the cache
      expect(firewall(cmd.jsonString) is FirewallPass, true);
    });

    test('should block when command overflow', () async {
      MaxAllowPostDuration = Duration(milliseconds: 900);
      for (int i = 0; i < MaxAllowPostCount; i++) {
        final cmdID = "not-overflow-" + identifier.randomNumber(5);
        final cmd = pb.Error()..code = cmdID;
        firewall(cmd.jsonString) is FirewallPass;
        firewallPostComplete(cmd.jsonString, pb.Error()); // set complete
      }
      final countBeforeExpire = cache.length;
      expect(countBeforeExpire >= MaxAllowPostCount, true);
      final cmdID2 = "overflow-" + identifier.randomNumber(5);
      final cmd2 = pb.Error()..code = cmdID2;
      expect(firewall(cmd2.jsonString) is FirewallBlock, true);
      await Future.delayed(Duration(seconds: 1));
      expect(firewall(cmd2.jsonString) is FirewallPass, true);
    });
  });
}
