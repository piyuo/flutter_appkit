// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'dataset_ram.dart';
import 'paged_data_view.dart';
import 'package:libcli/testing/testing.dart' as testing;

void main() {
  setUpAll(() async {});

  setUp(() async {});

  group('[data_view]', () {
    test('should set/get selected rows', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final dataView = PagedDataView<sample.Person>(
        dataset,
        loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
          return List.generate(limit, (index) => sample.Person()..id = index.toString());
        },
      );
      await dataView.load(testing.Context());
      await dataView.refresh(testing.Context());
      expect(dataView.hasSelectedRows, isFalse);

      dataView.setSelectedRows([dataView.displayRows[2]]);
      expect(dataView.hasSelectedRows, isTrue);
      expect(dataView.selectedCount, 1);

      final selected = dataView.getSelectedRows();
      expect(selected[0].id, '2');
      expect(dataView.isRowSelected(selected[0]), isTrue);
      expect(dataView.isRowSelected(dataView.displayRows[0]), isFalse);

      dataView.setSelected(['1']);
      expect(dataView.selectedCount, 1);
      expect(dataView.isRowSelected(dataView.displayRows[1]), isTrue);
    });
  });
}
