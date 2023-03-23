/// there are 3 different error type wee need to show to user
/// 1. network error, show retry button let user fix internet connection and retry
/// 2. try again later error, it's something wrong with server, show retry button let user retry later
/// 3. general exception, show error message and let user retry or go back

/// TryAgainLaterException is a error need user to retry later
class TryAgainLaterException implements Exception {
  /// RetryNetworkException is a network error that can be retried
  /// [message] is error message
  const TryAgainLaterException(this.message);

  /// message is error message
  final String message;

  @override
  String toString() => 'TryAgainLaterException: $message';
}
