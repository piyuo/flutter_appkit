// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'data_client.dart';
import 'dataset_ram.dart';

void main() {
  group('[data.data_client]', () {
    test('should load data with id by getter', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      bool isGet = false;
      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (id) async {
          isGet = true;
          return sample.Person()..id = 'myId';
        },
        saver: (_) async {},
      );

      final result = await dataClient.load(dataset: dataset, id: 'myId');
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
        creator: () async => sample.Person(),
        loader: (id) async {
          isGet = true;
          return sample.Person();
        },
        saver: (_) async {},
      );

      final result = await dataClient.load(dataset: dataset, id: '');
      expect(isGet, isFalse);
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);
    });

    test('should change when insert data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load();
      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (id) async => null,
        saver: (_) async {},
      );
      final result = await dataClient.load(dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.dataset.insert([person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should put first in dataset when save data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load();
      final exists = sample.Person()..name = 'exists';
      dataset.add([exists]);

      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (context) async => null,
        saver: (_) async {},
      );
      final result = await dataClient.load(dataset: dataset, id: '');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      final person = sample.Person()..name = 'john';
      await dataClient.dataset.insert([person]);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
    });

    test('should delete data', () async {
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      await dataset.load();
      final person = sample.Person()
        ..name = 'john'
        ..id = 'existsPerson';
      dataset.add([person]);

      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (context) async => null,
        saver: (_) async {},
      );
      final result = await dataClient.load(dataset: dataset, id: 'existsPerson');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      await dataClient.delete([person]);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });

    test('should save data', () async {
      sample.Person? saved;
      final dataset = DatasetRam<sample.Person>(objectBuilder: () => sample.Person());
      final person = sample.Person()
        ..name = 'john'
        ..id = 'person1';
      dataset.add([person]);

      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (context) async => null,
        saver: (items) async {
          saved = items[0];
        },
      );
      final result = await dataClient.load(dataset: dataset, id: 'person1');
      result.name = 'jo';
      dataClient.save([result]);
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
      dataset.add([person]);

      final dataClient = DataClient<sample.Person>(
        creator: () async => sample.Person(),
        loader: (id) async => null,
        saver: (items) async {
          saved = items[0];
        },
      );
      final result = await dataClient.load(dataset: dataset, id: 'person1');
      await dataClient.delete([result]);
      expect(saved, isNotNull);
      expect(saved!.id, 'person1');
      expect(saved!.deleted, isTrue);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });
  });
}
