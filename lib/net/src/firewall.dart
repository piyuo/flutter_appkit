import 'package:flutter/foundation.dart';
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;

/// [FirewallBlockEvent] happen when command send has been block by command service internal firewall
class FirewallBlockEvent {}

/// [_kMemoryKeyLastRequest] is cache key that identify last request
const _kMemoryKeyLastRequest = "net_req";

/// [_kMemoryKeyCall] is cache key that use to count overflow
const _kMemoryKeyCall = "net_call";

/// [kCacheDuration] is the time we cache last response
var kCacheDuration = const Duration(seconds: 30);

/// [kMaxAllowPostDuration] is firewall monitor duration
var kMaxAllowPostDuration = const Duration(minutes: 1);

/// [kMaxAllowPostCount] max allow post count in MaxAllowPostDuration
const kMaxAllowPostCount = 5;

/// firewall return true if action is allowed
///   1. it will block "IN_FLIGHT", stop send second request when same first request is not finish
///   2. it will block "OVERFLOW", stop send more than 5 request in 1 minutes, more than this limit consider it is a bug cause overflow
bool firewallBegin(Object action) {
  // check IN_FLIGHT/LAST_RESPONSE
  var lastReq = cache.get<Object>(_kMemoryKeyLastRequest);
  if (lastReq != null) {
    // in flight
    if (lastReq == action) {
      return false;
    }
  }

  // check OVERFLOW
  final currentCount = cache.beginWith(_kMemoryKeyCall);
  if (currentCount >= kMaxAllowPostCount) {
    eventbus.broadcast(FirewallBlockEvent());
    return false;
  }

  // track last command
  cache.put(_kMemoryKeyLastRequest, action, expire: kCacheDuration);
  // add call count for OVERFLOW detection
  cache.put(_kMemoryKeyCall + utils.randomNumber(6), null, expire: kMaxAllowPostDuration);
  return true;
}

/// firewallPostComplete must be call when post complete
void firewallEnd(Object action) {
  cache.delete(_kMemoryKeyLastRequest);
}

@visibleForTesting
void mockFirewallInFlight(Object action) {
  cache.put(_kMemoryKeyLastRequest, action, expire: kCacheDuration);
}
