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
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
        setter: (context, sample.Person person) async => person,
      );

      final result = await dataClient.load(testing.Context(), id: 'myId');
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
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
        setter: (context, sample.Person person) async => person,
      );

      final result = await dataClient.load(testing.Context(), id: '');
      expect(isGet, isFalse);
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);
    });

    test('should save data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load();
      final dataClient = DataClient<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        setter: (context, sample.Person person) async {
          person.entity = pb.Entity(id: 'newId');
          return person;
        },
      );
      final result = await dataClient.load(testing.Context(), id: '');
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);

      final person = sample.Person()..name = 'john';
      final success = await dataClient.save(testing.Context(), person);
      expect(success, isTrue);
      final firstPerson = await dataset.first;
      expect(firstPerson!.name, 'john');
      expect(firstPerson.entityID, 'newId');
    });

    test('should not save data if setter went wrong', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load();
      final dataClient = DataClient<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        setter: (context, sample.Person person) async {
          return null;
        },
      );
      final result = await dataClient.load(testing.Context(), id: '');
      expect(result, isNotNull);
      expect(dataset.isEmpty, true);

      final person = sample.Person()..name = 'john';
      final success = await dataClient.save(testing.Context(), person);
      expect(success, isFalse);
      expect(dataset.isEmpty, isTrue);
    });

    test('should delete data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load();
      final person = sample.Person()
        ..name = 'john'
        ..entity = pb.Entity(id: 'existsPerson');
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        remover: (context, sample.Person person) async {
          return true;
        },
      );
      final result = await dataClient.load(testing.Context(), id: 'existsPerson');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      final success = await dataClient.delete(testing.Context(), person);
      expect(success, isTrue);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNull);
    });

    test('should not delete data if remove return false', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.load();
      final person = sample.Person()
        ..name = 'john'
        ..entity = pb.Entity(id: 'existsPerson');
      dataset.add(testing.Context(), [person]);

      final dataClient = DataClient<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        remover: (context, sample.Person person) async {
          return false;
        },
      );
      final result = await dataClient.load(testing.Context(), id: 'existsPerson');
      expect(result, isNotNull);
      expect(dataset.isNotEmpty, true);

      final success = await dataClient.delete(testing.Context(), person);
      expect(success, isFalse);
      final firstPerson = await dataset.first;
      expect(firstPerson, isNotNull);
      expect(firstPerson!.entityID, 'existsPerson');
    });
  });
}
