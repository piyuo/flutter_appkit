// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'data_client.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  group('[data_client]', () {
    test('should load data with id by getter', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      bool isGet = false;
      final dataClient = DataClient<sample.Person>(
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
      );

      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'myId');
      expect(isGet, isTrue);
      expect(result, isNotNull);
      expect(dataset.length, 1);

      final row = await dataset.read('myId');
      expect(row!.entityID, 'myId');
    });

    test('should load no data with null id', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      bool isGet = false;
      final dataClient = DataClient<sample.Person>(
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
      );

      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(isGet, isFalse);
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);
    });

    test('should save data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final dataClient = DataClient<sample.Person>(
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.insert(testing.Context(), [person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should put first in dataset when save data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final exists = sample.Person()
        ..name = 'exists'
        ..entity = pb.Entity(id: 'existsPerson');
      dataset.add(testing.Context(), [exists]);

      final dataClient = DataClient<sample.Person>(
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.insert(testing.Context(), [person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should delete data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final person = sample.Person()
        ..name = 'john'
        ..entity = pb.Entity(id: 'existsPerson');
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'existsPerson');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      await dataClient.delete(testing.Context(), person);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });
  });
}
