import 'package:libcli/eventbus.dart' as eventbus;

/// InternalServerErrorEvent when [service return 500 internal server error], need let user know their network is slow than usual
///
class InternalServerErrorEvent {}

/// ServerNotReadyEvent when [service return 501 the remote servie is not properly setup], need let user know their network is slow than usual
///
class ServerNotReadyEvent {}

/// BadRequest when [service return 400 bad request], need let user know their network is slow than usual
///
class BadRequestEvent {}

/// RequestTimeoutContract happen when [TimeoutException] is thrown or [service meet context deadline exceed]
///
class RequestTimeoutContract extends eventbus.Contract {
  final dynamic exception;
  final String url;
  final String errorID;
  final bool isServer;
  RequestTimeoutContract(
      {this.exception, this.url, this.isServer, this.errorID});
}

/// NetworkSlowEvent happen when command [execute longer than usual]
///
class NetworkSlowEvent {}

/// ERefuseSignin happen when [user refuse to  sign in], let user know they need signin or register account
///
class ERefuseSignin {}

///InternetRequiredContract happen when [SocketException] [internet not connected], listener need let user connect to the internet then report back
///
class InternetRequiredContract extends eventbus.Contract {
  final dynamic exception;
  final String url;
  InternetRequiredContract({this.exception, this.url});
  Future<bool> Function() isInternetConnected;
  Future<bool> Function() isGoogleCloudFunctionAvailable;
}

///CAccessTokenRequired  happen when [service need access token], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenRequired extends eventbus.Contract {}

///CAccessTokenExpired happen when [access token expired], listener need let user sign in or use refresh token to get access token
///
class CAccessTokenExpired extends eventbus.Contract {}

///CPaymentTokenRequired happen when [service need payment token], listener need let user sign in immedately
///
class CPaymentTokenRequired extends eventbus.Contract {}
