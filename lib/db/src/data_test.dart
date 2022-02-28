// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/pb.dart' as pb;
import 'data.dart';
import 'db.dart';
import 'memory_ram.dart';

void main() {
  setUpAll(() async {});

  setUp(() async {});

  group('[data]', () {
    test('should open data by data', () async {
      bool isGet = false;
      final dp = Data<sample.Person>(
        dataBuilder: () => sample.Person(),
        dataGetter: (context, id) async {
          isGet = true;
          return null;
        },
        dataSetter: (context, sample.Person person) async => person,
      );

      await dp.byData(sample.Person());
      expect(isGet, isFalse);
      expect(dp.current, isNotNull);
      expect(dp.state == DataState.ready, true);
    });

    test('should open data by id', () async {
      bool isGet = false;
      final dp = Data<sample.Person>(
        dataBuilder: () => sample.Person(),
        dataGetter: (context, id) async {
          isGet = true;
          return sample.Person();
        },
        dataSetter: (context, sample.Person person) async => person,
      );

      await dp.byID(testing.Context(), 'id');
      expect(isGet, isTrue);
      expect(dp.current, isNotNull);
      expect(dp.state == DataState.ready, true);
    });

    test('should open data by memory', () async {
      final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'first'))]);
      bool isGet = false;
      final dp = Data<sample.Person>(
        dataBuilder: () => sample.Person(),
        dataGetter: (context, id) async {
          isGet = true;
          return sample.Person();
        },
        dataSetter: (context, sample.Person person) async => person,
      );

      await dp.byMemory('first', memory);
      expect(isGet, isFalse);
      expect(dp.current, isNotNull);
      expect(dp.state == DataState.ready, true);
    });

    test('should save data', () async {
      final memory = MemoryRam<sample.Person>(dataBuilder: () => sample.Person());
      await memory.open();
      await memory.add([sample.Person(entity: pb.Entity(id: 'hi'))]);
      final dp = Data<sample.Person>(
        dataBuilder: () => sample.Person(),
        dataGetter: (context, id) async => null,
        dataSetter: (context, sample.Person person) async {
          person.name = 'john';
          return person;
        },
      );
      await dp.byMemory('hi', memory);
      dp.current!.age = 12;
      await dp.save(testing.Context());
      expect(dp.state == DataState.ready, true);
      final person2 = await memory.first;
      expect(person2!.name, 'john');
      expect(person2.age, 12);
      expect(person2.entityID, 'hi');
    });
  });
}
