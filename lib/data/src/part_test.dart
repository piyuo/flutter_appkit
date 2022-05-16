// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'part.dart';
import 'dataset_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  group('[data]', () {
    test('should load data with id by getter', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      bool isGet = false;
      final detail = Part<sample.Person>(
        dataset,
        id: 'myId',
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
        setter: (context, sample.Person person) async => person,
      );

      await detail.load(testing.Context());
      expect(isGet, isTrue);
      expect(detail.current, isNotNull);
      expect(dataset.length, 1);
      expect(detail.isLoading, false);

      final row = await dataset.read('myId');
      expect(row!.entityID, 'myId');
    });

    test('should load no data with null id', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      bool isGet = false;
      final detail = Part<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async {
          isGet = true;
          return sample.Person(entity: pb.Entity(id: 'myId'));
        },
        setter: (context, sample.Person person) async => person,
      );

      await detail.load(testing.Context());
      expect(isGet, isFalse);
      expect(detail.current, isNull);
      expect(dataset.isEmpty, true);
      expect(detail.isLoading, false);
    });

    test('should save data', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.open();
      final detail = Part<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        setter: (context, sample.Person person) async {
          person.entity = pb.Entity(id: 'newId');
          return person;
        },
      );
      await detail.load(testing.Context());
      expect(detail.current, isNull);
      expect(dataset.isEmpty, true);
      expect(detail.isLoading, false);

      detail.current = sample.Person()..name = 'john';
      final success = await detail.save(testing.Context());
      expect(success, isTrue);
      final person = await dataset.first;
      expect(person!.name, 'john');
      expect(person.entityID, 'newId');
    });

    test('should not save data if setter went wrong', () async {
      final dataset = DatasetRam<sample.Person>(dataBuilder: () => sample.Person());
      await dataset.open();
      final detail = Part<sample.Person>(
        dataset,
        dataBuilder: () => sample.Person(),
        getter: (context, id) async => null,
        setter: (context, sample.Person person) async {
          return null;
        },
      );
      await detail.load(testing.Context());
      expect(detail.current, isNull);
      expect(dataset.isEmpty, true);
      expect(detail.isLoading, false);

      detail.current = sample.Person()..name = 'john';
      final success = await detail.save(testing.Context());
      expect(success, isFalse);
      expect(dataset.isEmpty, isTrue);
    });
  });
}
