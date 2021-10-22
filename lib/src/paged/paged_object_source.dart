import 'package:flutter/material.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/disk_cache.dart' as disk_cache;
import 'paged_data_source.dart';
import 'types.dart';

class PagedObjectSource<T extends pb.Object> extends PagedDataSource<T> {
  PagedObjectSource({
    required String key,
    required pb.ObjectBuilder<T> objectBuilder,
    required DataLoader<T> dataLoader,
    DataRefresher<T>? dataRefresher,
    DataRemover<T>? dataRemover,
  }) : super(
          dataLoader: dataLoader,
          dataRefresher: dataRefresher,
          dataRemover: dataRemover,
          dataComparator: (pb.Object src, pb.Object dest) => src.compareTo(dest),
          diskCacheWriter: (BuildContext context, CacheInstruction<T> instruction) async {
            final json = {
              'rpp': instruction.rowsPerPage,
              'stat': instruction.status.index,
              'rows': pb.formatObjectList(instruction.rows),
            };
            await disk_cache.add(key, json);
            return;
          },
          diskCacheReader: (BuildContext context) async {
            final json = await disk_cache.get(key);
            if (json == null) {
              return null;
            }
            final rows = pb.parseObjectList<T>(json['rows'], objectBuilder);
            final status = PagedDataSourceStatus.values[json['stat']];
            return CacheInstruction(
              rows: [...rows],
              status: status,
              rowsPerPage: json['rpp'],
            );
          },
        );
}
