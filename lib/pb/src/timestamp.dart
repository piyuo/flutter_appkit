import 'package:libcli/pb/google.dart' as google;

extension TimestampOnDateTime on DateTime {
  /// timestamp return google timestamp
  google.Timestamp get timestamp => google.Timestamp.fromDateTime(this);

  /// utcTimestamp return utc google timestamp
  google.Timestamp get utcTimestamp => google.Timestamp.fromDateTime(toUtc());
}
