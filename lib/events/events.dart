import 'package:libcli/event_bus/event_bus.dart';

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
class ENetworkSlow {}

///ERefuseInternet happen when user refuse to  connect to internet, listener let user know they need connect to then internet
class ERefuseInternet {}

///ERefuseSignin happen when user refuse to  sign in, let user know they need signin or register account
class ERefuseSignin {}

///EServiceBlocked happen when internet is connected but can't connect to www.cloudfunctions.net, uausally mean block by firewall
class EServiceBlocked {}

///EContactUs happen when there is unknow error and we can't log it. the only way to solve this is contact us
class EContactUs {
  var e;
  var s;
  EContactUs(this.e, this.s);
}

///EError happen when there is a  error and we already logged. prompt user with error id to let them track issue
class EError {
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
