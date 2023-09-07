import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter/material.dart';
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Inventory {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  Inventory({
    required this.name,
    required this.description,
  });
}

main() {
  base.start(
    routesBuilder: () => {
      '/': (context, state, data) => const DbExample(),
    },
  );
}

class DbExample extends StatelessWidget {
  const DbExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    paddingToTablet() {
      return Column(children: [
        OutlinedButton(
            child: const Text('helloWorld'),
            onPressed: () async {
              final dbProvider = data.IndexedDbProvider();
              await dbProvider.init('data_sample');
              await dbProvider.put('hello', 'world');
              var name = await dbProvider.get('hello');
              debugPrint('hello:$name');
            }),
        /*OutlinedButton(
          child: const Text('custom type'),
          onPressed: () async {
            final testDB = await open('testDB');
            testDB.set(
                'i',
                Inventory(
                  name: 'name',
                  description: 'description',
                ));
            var inventory = await testDB.get('i');
            debugPrint('Name: ${inventory.name}');
          }),*/
        OutlinedButton(
            child: const Text('pb.Object'),
            onPressed: () async {
              final dbProvider = data.IndexedDbProvider();
              await dbProvider.init('data_sample');
              await dbProvider.addRow('e', sample.Person(name: '123'));
              var person = await dbProvider.getRow<sample.Person>('e', () => sample.Person());
              debugPrint('person name: ${person!.name}');
            }),
      ]);
    }

    return testing.ExampleScaffold(
      builder: paddingToTablet,
      buttons: [
        testing.ExampleButton('padding to tablet', builder: paddingToTablet),
      ],
    );
  }
}
