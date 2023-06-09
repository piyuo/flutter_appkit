import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/google/google.dart' as google;

/// Local is where to keep data
abstract class Local<T extends pb.Object> {
  /// getNewestTime return newest row time
  google.Timestamp? getNewestTime();

  /// getOldestTime return oldest row time
  google.Timestamp? getOldestTime();

  /// isNoMoreOnRemote return true if no more data on remote
  bool isNoMoreOnRemote();

  /// getObjectById return object by id, null if not exists
  Future<T?> getObjectById(String id);

  /// init load data from database and remove old data use cutOffDays
  Future<void> init();

  /// dispose data
  void dispose();

  /// add rows to database and set noMoreData
  Future<void> add(List<T> rows, bool noMoreOnRemote);

  /// clear data in database
  Future<void> clear();

  /// query return list of model that match query
  Future<Iterable<pb.Model>> query({
    bool sortNewestFirst = true,
    bool skipDeleted = true,
    DateTime? from,
    DateTime? to,
    int start = 0,
    int length = 0,
  });
}
