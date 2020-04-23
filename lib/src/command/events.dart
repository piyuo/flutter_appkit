import 'package:libcli/eventbus.dart' as eventbus;

/// ServerInternalErrorEvent when [service return 500 internal server error], need let user know their network is slow than usual
///
class ServerInternalErrorEvent {}

/// InternalServerErrorEvent when [service return 501 the remote servie is not properly setup], need let user know their network is slow than usual
///
class ServerNeedSetupEvent {}

/// ServerBadRequest when [service return 400 bad request], need let user know their network is slow than usual
///
class ServerBadRequest {}

/// NetworkSlowEvent happen when command [execute longer than usual]
///
class NetworkSlowEvent {}

/// NetworkDeadlineExceedEvent  happen when [service meet context deadline exceed], listener let user know they can try again later or contact us with errId to get solution
///
class NetworkDeadlineExceedEvent {
  final String errorID;
  NetworkDeadlineExceedEvent(this.errorID);
}

/// NetworkServiceNotAvailableEvent happen when internet is connected but google service is down
///
class NetworkServiceNotAvailableEvent {}

/// NetworkServiceBlocked happen when internet is connected but can not connect to google service is down
///
class NetworkServiceBlocked {}

/// NetworkTimeoutEvent happen when [TimeoutException] is thrown
///
class NetworkTimeoutEvent {}

/// ERefuseInternet happen when [user refuse to  connect] to internet, listener let user know they need connect to then internet
///
class ERefuseInternet {}

/// ERefuseSignin happen when [user refuse to  sign in], let user know they need signin or register account
///
class ERefuseSignin {}

///InternetRequiredContract happen when [SocketException] [internet not connected], listener need let user connect to the internet then report back
///
class InternetRequiredContract extends eventbus.Contract {}

///CAccessTokenRequired  happen when [service need access token], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenRequired extends eventbus.Contract {}

///CAccessTokenExpired happen when [access token expired], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenExpired extends eventbus.Contract {}

///CPaymentTokenRequired happen when [service need payment token], listener need let user sign in immedately
///
class CPaymentTokenRequired extends eventbus.Contract {}
