import 'package:flutter/foundation.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/memory/memory.dart' as memory;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/generator/generator.dart' as generator;

/// _blockList keep action need block
final _blockList = memory.MemoryCache();

/// FirewallBlockEvent happen when command send has been block by command service internal firewall
class FirewallBlockEvent extends eventbus.Event {
  String reason;
  FirewallBlockEvent(this.reason);
}

/// FirewallPass is firewall return result
class FirewallPass extends pb.Empty {}

/// FirewallBlock is firewall return result
class FirewallBlock extends pb.Empty {
  String reason;
  FirewallBlock(this.reason);
}

/// blockShort is server request to block this command for short period of time
const blockShort = 'BLOCK_SHORT';

/// blockLong is server request to block this command for long period of time
const blockLong = 'BLOCK_LONG';

/// inFlight is previous command still in flight
const inFlight = 'IN_FLIGHT';

/// overflow is command run too many times
const overflow = 'OVERFLOW';

/// memoryKeyLastRequest is cache key that identify last request
const memoryKeyLastRequest = "CMD_LAST_ACTION";

/// memoryKeyLastResponse is cache key that identify last response
const memoryKeyLastResponse = "CMD_LAST_RESPONSE";

/// memoryKeyCall is cache key that use to count overflow
const memoryKeyCall = "CMD_CALL_";

/// CacheDuration is the time we cache last response
var cacheDuration = const Duration(seconds: 30);

/// MaxAllowPostDuration is firewall monitor duration
var maxAllowPostDuration = const Duration(minutes: 8);

/// MaxAllowPostCount max allow post count in MaxAllowPostDuration
const maxAllowPostCount = 96;

/// firewallDisable set to true will disable firewall
bool firewallDisable = false;

/// BlockShortDuration define time of short duration
var blockShortDuration = const Duration(minutes: 1);

/// BlockLongDuration define time of long duration
var blockLongDuration = const Duration(days: 1);

/// firewall return true if command is allowed
///   1. it will block "IN_FLIGHT", stop send second command when same first command is not finish
///   2. it will block "OVERFLOW", stop send more than 96 command in 8 minutes, this equal 1 post/5s, more than this limit consider it is a bug cause overflow
///   3. it will cache "LAST_RESPONSE", return last response if same request happen in 30 seconds
///   4. it will block command for 1 minutes when receive server "BLOCK_SHORT"
///   5. it will block command for 24 hour when receive server "BLOCK_LONG"
pb.Object firewallBegin(pb.Object action) {
  if (firewallDisable) {
    return FirewallPass();
  }

  // check block by server
  var blocked = _blockList.get(action);
  if (blocked != null) {
    return FirewallBlock(blocked);
  }

  // check IN_FLIGHT/LAST_RESPONSE
  var lastReq = memory.get<pb.Object>(memoryKeyLastRequest);
  if (lastReq != null) {
    // hit cache
    if (lastReq == action) {
      final response = memory.get(memoryKeyLastResponse);
      if (response != null) {
        // LAST_RESPONSE
        return response;
      } else {
        // IN_FLIGHT
        return FirewallBlock(inFlight);
      }
    }
  }

  // check OVERFLOW
  final currentCount = memory.beginWith(memoryKeyCall);
  if (currentCount >= maxAllowPostCount) {
    return FirewallBlock(overflow);
  }

  // track last command
  memory.set(memoryKeyLastRequest, action, expire: cacheDuration);
  memory.delete(memoryKeyLastResponse);

  // add call count for OVERFLOW detection
  memory.set(memoryKeyCall + generator.randomNumber(6), null, expire: maxAllowPostDuration);
  return FirewallPass();
}

/// firewallPostComplete must be call when post complete
void firewallEnd(pb.Object action, pb.Object? response) {
  if (firewallDisable) {
    return;
  }

  if (response == null) {
    // something wrong with post, just delete cache
    memory.delete(memoryKeyLastRequest);
    memory.delete(memoryKeyLastResponse);
    return;
  }
  // update request cache time, make sure request and response will expire at the same time
  memory.set(memoryKeyLastRequest, action, expire: cacheDuration);
  memory.set(memoryKeyLastResponse, response, expire: cacheDuration);

  // check block by server
  if (response is pb.Error) {
    if (response.code == blockShort) {
      _blockList.set(action, blockShort, expire: blockShortDuration);
    }
    if (response.code == blockLong) {
      _blockList.set(action, blockLong, expire: blockLongDuration);
    }
  }
}

@visibleForTesting
void mockFirewallInFlight(pb.Object action) {
  memory.set(memoryKeyLastRequest, action, expire: cacheDuration);
  memory.delete(memoryKeyLastResponse);
}
