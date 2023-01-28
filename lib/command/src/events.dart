import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/util/util.dart' as util;

/// InternalServerErrorEvent happen when [service return 500 internal server error], need let user know their network is slow than usual
class InternalServerErrorEvent extends eventbus.Event {}

/// ServerNotReadyEvent happen when [service return 501 the remote service is not properly setup], need let user know their network is slow than usual
class ServerNotReadyEvent extends eventbus.Event {}

/// BadRequestEvent happen when [service return 400 bad request], need let user know their network is slow than usual
class BadRequestEvent extends eventbus.Event {}

/// NoAccessTokenEvent happen when action need access token and service cannot provide one
class NoAccessTokenEvent extends eventbus.Event {}

/// TooManyRetryEvent happen when action retry count exceed limit
class TooManyRetryEvent extends eventbus.Event {}

/// RequestTimeoutContract happen when [TimeoutException] is thrown or [service meet context deadline exceed]
class RequestTimeoutContract extends eventbus.Contract {
  final String url;
  final bool isServer;
  final dynamic exception;

  /// errorID will be set if is server timeout
  final String errorID;

  RequestTimeoutContract({
    this.exception,
    required this.url,
    required this.isServer,
    this.errorID = '',
  });
}

/// SlowNetworkEvent happen when command [execute longer than usual]
class SlowNetworkEvent extends eventbus.Event {}

/// ERefuseSignin happen when [user refuse to  sign in], let user know they need signin or register account
class ERefuseSignin extends eventbus.Event {}

/// InternetRequiredContract happen when [SocketException] [internet not connected], listener need let user connect to the internet then report back
class InternetRequiredContract extends eventbus.Contract {
  final dynamic exception;
  final String url;
  InternetRequiredContract({
    this.exception,
    required this.url,
  });

  /// isInternetConnected is a function that return true if internet is connected
  Future<bool> Function() isInternetConnected = util.isInternetConnected;

  /// isGoogleCloudFunctionAvailable is a function that return true if google cloud function is available
  Future<bool> Function() isGoogleCloudFunctionAvailable = util.isGoogleCloudFunctionAvailable;
}
