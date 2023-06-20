import 'package:libcli/pb/pb.dart' as pb;

/// SyncResult is the result of sync
class SyncResult<T> {
  SyncResult({
    this.refreshRows = const [],
    this.fetchRows = const [],
    this.more = false,
  });

  /// refreshRows is the list of rows that for refresh
  final List<T> refreshRows;

  /// fetchRows is the list of rows that for fetch
  final List<T> fetchRows;

  /// more is true if there are more data on remote
  final bool more;
}

/// DataLoader is a function to load data from remote, return [SyncResult]
typedef DataLoader<T extends pb.Object> = Future<SyncResult<T>> Function(pb.Sync sync);
