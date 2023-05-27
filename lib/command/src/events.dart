import 'package:libcli/utils/utils.dart' as general;

/// InternalServerErrorEvent happen when [service return 500 internal server error], need let user know their network is slow than usual
class InternalServerErrorEvent {}

/// ServerNotReadyEvent happen when [service return 501 the remote service is not properly setup], need let user know their network is slow than usual
class ServerNotReadyEvent {}

/// BadRequestEvent happen when [service return 400 bad request], need let user know their network is slow than usual
class BadRequestEvent {}

/// NeedLoginEvent happen when action need access token and user need login
class NeedLoginEvent {}

/// TooManyRetryEvent happen when action retry count exceed limit
class TooManyRetryEvent {}

/// AccessTokenRevokedEvent happen when access token is revoked
class AccessTokenRevokedEvent {
  AccessTokenRevokedEvent(this.invalidToken);
  final String? invalidToken;
}

/// ForceLogOutEvent happen when remote service force user to logout
class ForceLogOutEvent {}

/// RequestTimeoutEvent happen when [TimeoutException] is thrown or [service meet context deadline exceed]
class RequestTimeoutEvent {
  final String url;
  final bool isServer;
  final dynamic exception;

  /// errorID will be set if is server timeout
  final String errorID;

  RequestTimeoutEvent({
    this.exception,
    required this.url,
    required this.isServer,
    this.errorID = '',
  });
}

/// SlowNetworkEvent happen when command [execute longer than usual]
class SlowNetworkEvent {}

/// InternetRequiredEvent happen when [SocketException] [internet not connected], listener need let user connect to the internet then report back
class InternetRequiredEvent {
  final dynamic exception;
  final String url;
  InternetRequiredEvent({
    this.exception,
    required this.url,
  });

  /// isInternetConnected is a function that return true if internet is connected
  Future<bool> Function() isInternetConnected = general.isInternetConnected;

  /// isGoogleCloudFunctionAvailable is a function that return true if google cloud function is available
  Future<bool> Function() isGoogleCloudFunctionAvailable = general.isGoogleCloudFunctionAvailable;
}
