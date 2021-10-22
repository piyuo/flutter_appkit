import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/util.dart' as utils;

/// InternalServerErrorEvent happen when [service return 500 internal server error], need let user know their network is slow than usual
///
class InternalServerErrorEvent extends eventbus.Event {}

/// ServerNotReadyEvent happen when [service return 501 the remote servie is not properly setup], need let user know their network is slow than usual
///
class ServerNotReadyEvent extends eventbus.Event {}

/// BadRequestEvent happen when [service return 400 bad request], need let user know their network is slow than usual
///
class BadRequestEvent extends eventbus.Event {}

/// RequestTimeoutContract happen when [TimeoutException] is thrown or [service meet context deadline exceed]
///
class RequestTimeoutContract extends eventbus.Contract {
  final String url;
  final bool isServer;
  final dynamic exception;

  /// errorID will be set if is server timeout
  ///
  final String errorID;

  RequestTimeoutContract({
    this.exception,
    required this.url,
    required this.isServer,
    this.errorID = '',
  });
}

/// SlowNetworkEvent happen when command [execute longer than usual]
///
class SlowNetworkEvent extends eventbus.Event {}

/// ERefuseSignin happen when [user refuse to  sign in], let user know they need signin or register account
///
class ERefuseSignin extends eventbus.Event {}

///InternetRequiredContract happen when [SocketException] [internet not connected], listener need let user connect to the internet then report back
///
class InternetRequiredContract extends eventbus.Contract {
  final dynamic exception;
  final String url;
  InternetRequiredContract({
    this.exception,
    required this.url,
  });

  Future<bool> Function() isInternetConnected = utils.isInternetConnected;
  Future<bool> Function() isGoogleCloudFunctionAvailable = utils.isGoogleCloudFunctionAvailable;
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
