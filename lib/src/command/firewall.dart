import 'package:libcli/eventbus.dart' as eventbus;
import 'package:libcli/cache.dart' as cache;
import 'package:libpb/pb.dart' as pb;
import 'package:libcli/identifier.dart' as identifier;

/// FirewallBlockEvent happen when command send has been block by command service internal firewall
///
class FirewallBlockEvent extends eventbus.Event {}

/// FirewallPass is firewall return result
///
class FirewallPass extends pb.Empty {}

/// FirewallBlock is firewall return result
///
class FirewallBlock extends pb.Empty {}

/// CacheKeyLastRequest is cache key that identify last request
const CacheKeyLastRequest = "CMD_LAST_REQUEST";

/// CacheKeyLastResponse is cache key that identify last response
const CacheKeyLastResponse = "CMD_LAST_RESPONSE";

/// CacheKeyCall is cache key that use to count overflow
const CacheKeyCall = "CMD_CALL_";

/// CacheDuration is the time we cache last response
var CacheDuration = Duration(seconds: 30);

/// MaxAllowPostDuration is firewall monitor duration
var MaxAllowPostDuration = Duration(minutes: 8);

/// MaxAllowPostCount max allow post count in MaxAllowPostDuration
const MaxAllowPostCount = 96;

/// firewallDisable set to true will disable firewall
bool firewallDisable = false;

/// firewall return true if command is allowed
///   1. it will block "IN_FLIGHT", stop send second command when same first command is not finish
///   2. it will block "OVERFLOW", stop send more than 96 command in 8 minutes, this equal 1 post/5s, more than this limit consider it is a bug cause overflow
///   3. it will cache "LAST_RESPONSE", return last response if same request happen in 30 seconds
///
pb.Object firewall(String cmdJSON) {
  if (firewallDisable) {
    return FirewallPass();
  }

  // check IN_FLIGHT/LAST_RESPONSE
  var lastReq = cache.get(CacheKeyLastRequest);
  if (lastReq != null && lastReq is String) {
    // hit cache
    if (lastReq == cmdJSON) {
      final response = cache.get(CacheKeyLastResponse);
      if (response != null) {
        // LAST_RESPONSE
        return response;
      } else {
        // IN_FLIGHT
        return FirewallBlock();
      }
    }
  }

  // check OVERFLOW
  final currentCount = cache.beginWith(CacheKeyCall);
  if (currentCount >= MaxAllowPostCount) {
    return FirewallBlock();
  }

  // track last command
  cache.set(CacheKeyLastRequest, cmdJSON, expire: CacheDuration);
  cache.delete(CacheKeyLastResponse);

  // add call count for OVERFLOW detection
  cache.set(CacheKeyCall + identifier.randomNumber(6), null, expire: MaxAllowPostDuration);

  return FirewallPass();
}

/// firewallPostComplete must be call when post complete
///
void firewallPostComplete(String cmdJSON, pb.Object response) {
  if (firewallDisable) {
    return;
  }
  // update request cache time, make sure request and response will expire at the same time
  cache.set(CacheKeyLastRequest, cmdJSON, expire: CacheDuration);
  cache.set(CacheKeyLastResponse, response, expire: CacheDuration);
}

void mockFirewallInFlight(String cmdJSON) {
  cache.set(CacheKeyLastRequest, cmdJSON, expire: CacheDuration);
  cache.delete(CacheKeyLastResponse);
}
