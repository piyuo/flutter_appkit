// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/storage/storage.dart' as storage;
import 'paged_object_source.dart';
import 'types.dart';

void main() {
  setUp(() async {
    storage.clear();
  });

  group('[paged_object_source]', () {
    test('should use disk cache', () async {
      int refreshCount = 0;
      PagedObjectSource<pb.Error> pos = PagedObjectSource(
        key: 'mySource',
        objectBuilder: () => pb.Error(),
        dataLoader: (BuildContext context, pb.Error? last, int length) async {
          if (refreshCount == 0) {
            refreshCount++;
            return List.generate(10, (index) => pb.Error()..code = index.toString());
          }
          return List.generate(2, (index) => pb.Error()..code = 'add ' + index.toString());
        },
        dataRefresher: (BuildContext context, pb.Object? first, int rowsPerPage) async {
          return RefreshInstruction(updated: [], deleted: []);
        },
        dataRemover: (BuildContext context, List<pb.Object> removeList) async => true,
      );
      await pos.loadMoreRow(testing.Context());
      await pos.setRowsPerPage(testing.Context(), 20);
      expect(pos.length, 12);
      expect(pos.pageCount, 1);
      expect(pos.status, PagedDataSourceStatus.end);

      PagedObjectSource<pb.Error> pos2 = PagedObjectSource(
        key: 'mySource',
        objectBuilder: () => pb.Error(),
        dataLoader: (BuildContext context, pb.Error? last, int length) async {
          return [];
        },
        dataRefresher: (BuildContext context, pb.Object? first, int rowsPerPage) async {
          return RefreshInstruction(updated: [], deleted: []);
        },
        dataRemover: (BuildContext context, List<pb.Object> removeList) async => true,
      );
      await pos2.init(testing.Context());
      expect(pos2.length, 12);
      expect(pos2.rowsPerPage, 20);
      expect(pos2.pageCount, 1);
      expect(pos2.status, PagedDataSourceStatus.end);
    });
  });
}
