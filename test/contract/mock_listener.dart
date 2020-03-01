import 'package:libcli/contract/contract.dart' as contract;
import 'dart:async';

class MockEvent extends contract.Event {}

class MockContract extends contract.Contract {}

class MockListener extends contract.Listener {
  contract.Contract latestContract;
  contract.Event latestEvent;
  bool ok = false;

  MockListener(this.ok);

  clear() {
    latestEvent = null;
    latestEvent = null;
  }

  @override
  bool check(contract.Contract c) {
    latestContract = c;
    Timer.run(() {
      c.complete(ok);
    });
    return true;
  }

  @override
  void listen(contract.Event event) {
    latestEvent = event;
  }
}
