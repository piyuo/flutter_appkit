library contract;

import 'dart:async';
import 'package:libcli/log/log.dart' as log;

const _here = 'contract';

/// Event notify all listener something is happen and caller do not expect any response
abstract class Event {}

/// Contract need listener do something and need callback when job is done
abstract class Contract extends Event {
  Completer<bool> _completer = new Completer<bool>();
  void complete(bool ok) {
    var text = ok ? '\u001b[32mok' : '\u001b[31mfailed';
    log.debug(_here, '${this.runtimeType} $text');
    _completer.complete(ok);
  }

  Future<bool> get future {
    return _completer.future;
  }
}

/// Listener listen event and check contract can be take
abstract class Listener {
  //return true if take the contract
  bool check(Contract contract) {
    return false;
  }

  void listen(Event event) {}
}

var _listeners = new List<Listener>();

/// caller open contract, need call back when job done
///
///     ContractConnectInternet contract = await contract.open(ContractConnectInternet);
///     if(contract.connected) print('internet is connected');
Future<bool> open(Contract contract) {
  bool takeJob = false;
  for (Listener listener in _listeners) {
    try {
      if (listener.check(contract)) {
        takeJob = true;
        log.debug(
            _here, '${contract.runtimeType} taken by ${listener.runtimeType}');
        break;
      }
    } catch (e, s) {
      log.error(_here, e, s);
      contract.complete(false);
    }
  }
  assert(takeJob == true,
      '$_here broken, no listener for ${contract.runtimeType}');
  return contract.future;
}

/// caller broadcast event to all listener
///
///    contract.broadcast(EventSlowInternet);
void brodcast(Event event) {
  log.debug(_here, 'brodcast ${event.runtimeType}');
  for (Listener listener in _listeners) {
    try {
      listener.listen(event);
    } catch (e, s) {
      log.error(_here, e, s);
    }
  }
}

/// add listener
///
///     contract.addListener(listener);
void addListener(Listener listener) {
  _listeners.add(listener);
}

/// print debug info to console
///
///     contract.removeListener(listener);
void removeListener(Listener listener) {
  _listeners.remove(listener);
}

///
/// for test and debug purpos
///

/// listenerCount is current listener count
///
///     contract.listenerCount();
int listenerCount() {
  return _listeners.length;
}

/// clearAllListener remove all listener from contract
///
///     contract.removeAllListener();
void removeAllListener() {
  _listeners.clear();
}

///
/// contracts
///

///CInternetRequired  happen when internet not connected, listener need let user connect to the internet then report back
class CInternetRequired extends Contract {}

///CAccessTokenRequired  happen when service need access token, listener need let user sign in or use refresh token to get access token
class CAccessTokenRequired extends Contract {}

///CAccessTokenExpired happen when access token expired, listener need let user sign in or use refresh token to get access token
class CAccessTokenExpired extends Contract {}

///CPaymentTokenRequired happen when service need payment token, listener need let user sign in immedately
class CPaymentTokenRequired extends Contract {}

///
/// events
///

///ENetworkSlow happen when http post take too long, need let user know their network is slow than usual
class ENetworkSlow extends Event {}

///ERefuseInternet happen when user refuse to  connect to internet, listener let user know they need connect to then internet
class ERefuseInternet extends Event {}

///ERefuseSignin happen when user refuse to  sign in, let user know they need signin or register account
class ERefuseSignin extends Event {}

///EServiceBlocked happen when internet is connected but can't connect to www.cloudfunctions.net, uausally mean block by firewall
class EServiceBlocked extends Event {}

///EContactUs happen when there is unknow error and we can't log it. the only way to solve this is contact us
class EContactUs extends Event {
  var e;
  var s;
  EContactUs(this.e, this.s);
}

///EError happen when there is a  error and we already logged. prompt user with error id to let them track issue
class EError extends Event {
  String errId;
  EError(this.errId);
}

//EServiceTimeout  happen when service meet context deadline exceed, listener let user know they can try again later or contact us with errId to get solution
class EServiceTimeout extends EError {
  EServiceTimeout(errId) : super(errId);
}

//EClientTimeout  happen when client http post timeout. this usually mean bug because service should always timeout first. somethins is wrong with service/client timeout setup
class EClientTimeout extends EError {
  EClientTimeout(errId) : super(errId);
}
