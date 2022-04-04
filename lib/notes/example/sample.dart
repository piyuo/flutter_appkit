import 'package:flutter/material.dart';
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/meta/sample/sample.dart' as sample;

class SamplePagedDataset extends db.PagedDataset<sample.Person> {
  SamplePagedDataset(BuildContext context)
      : super(
          db.MemoryRam(dataBuilder: () => sample.Person()),
          dataBuilder: () => sample.Person(),
          loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
            return List.generate(returnCount, (i) => sample.Person(entity: pb.Entity(id: '$returnID-$i')));
          },
        ) {
    start(context);
  }

  static String returnID = 'A';

  static int returnCount = 10;
}

int refreshCount = 0;

class SamplePagedTable extends db.PagedTable<sample.Person> {
  SamplePagedTable(BuildContext context)
      : super(
          db.MemoryRam(dataBuilder: () => sample.Person()),
          id: 'test',
          dataBuilder: () => sample.Person(),
          loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
            refreshCount++;
            return List.generate(
                returnCount,
                (i) => sample.Person(
                      name: 'name$refreshCount-$i',
                      age: i,
                      entity: pb.Entity(id: '$returnID-$refreshCount-$i'),
                    ));
          },
        ) {
    start(context);
  }

  static String returnID = 'A';

  static int returnCount = 10;
}
