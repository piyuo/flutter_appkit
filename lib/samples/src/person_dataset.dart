import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/unique/unique.dart' as unique;

class PersonDataset extends db.Dataset<sample.Person> {
  PersonDataset()
      : super(
          db.MemoryRam(dataBuilder: () => sample.Person()),
          dataBuilder: () => sample.Person(),
          loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
            final uuid = unique.uuid();
            return List.generate(
              returnCount,
              (i) => sample.Person(
                name: uuid,
                entity: pb.Entity(id: uuid),
              ),
            );
          },
        );

  static int returnCount = 1;
}
