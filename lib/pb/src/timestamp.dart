import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/pb/google.dart' as google;

extension TimestampOnDateTime on DateTime {
  /// toTimestamp
  google.Timestamp get timestamp => google.Timestamp.fromDateTime(this);
}
