// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/sample/sample.dart' as sample;
import 'data_client.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  group('[data_client]', () {
    test('should load data with id by getter', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      bool isGet = false;
      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async {
          isGet = true;
          return sample.Person()..id = 'myId';
        },
        saver: (_, __) async {},
      );

      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'myId');
      expect(isGet, isTrue);
      expect(result, isNotNull);
      expect(dataset.length, 1);

      final row = await dataset.read('myId');
      expect(row!.id, 'myId');
    });

    test('should load no data with null id', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      bool isGet = false;
      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async {
          isGet = true;
          return sample.Person();
        },
        saver: (_, __) async {},
      );

      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(isGet, isFalse);
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);
    });

    test('should change when insert data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, __) async {},
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.dataset.insert(testing.Context(), [person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should put first in dataset when save data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final exists = sample.Person()..name = 'exists';
      dataset.add(testing.Context(), [exists]);

      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, __) async {},
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.dataset.insert(testing.Context(), [person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should delete data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load(testing.Context());
      final person = sample.Person()
        ..name = 'john'
        ..id = 'existsPerson';
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, __) async {},
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'existsPerson');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      await dataClient.delete(testing.Context(), [person]);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });

    test('should save data', () async {
      sample.Person? saved;
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final person = sample.Person()
        ..name = 'john'
        ..id = 'person1';
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, items) async {
          saved = items[0];
        },
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'person1');
      result.name = 'jo';
      dataClient.save(testing.Context(), [result]);
      expect(saved, isNotNull);
      expect(saved!.name, 'jo');
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'jo');
    });

    test('should delete data', () async {
      sample.Person? saved;
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final person = sample.Person()
        ..name = 'john'
        ..id = 'person1';
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, items) async {
          saved = items[0];
        },
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'person1');
      await dataClient.delete(testing.Context(), [result]);
      expect(saved, isNotNull);
      expect(saved!.id, 'person1');
      expect(saved!.isDeleted, isTrue);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });

    test('should archive data', () async {
      sample.Person? saved;
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final person = sample.Person()
        ..name = 'john'
        ..id = 'person1';
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        creator: () => sample.Person(),
        loader: (context, id) async => null,
        saver: (_, items) async {
          saved = items[0];
        },
      );
      final result = await dataClient.load(testing.Context(), dataset: dataset, id: 'person1');
      await dataClient.archive(testing.Context(), [result]);
      expect(saved, isNotNull);
      expect(saved!.id, 'person1');
      expect(saved!.isArchived, isTrue);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });
  });
}
