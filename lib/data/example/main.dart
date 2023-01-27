import 'package:libcli/sample/sample.dart' as sample;
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/database/database.dart' as database;
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
  app.start(
    routes: {
      '/': (context, state, data) => const DbExample(),
    },
  );
}

class DbExample extends StatelessWidget {
  const DbExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: _sample(context)),
      Wrap(
        children: [
          testing.ExampleButton(
            label: 'padding to tablet',
            builder: () => _sample(context),
          ),
        ],
      )
    ]);
  }

  Widget _sample(BuildContext context) {
    return Column(children: [
      OutlinedButton(
          child: const Text('helloWorld'),
          onPressed: () async {
            final testDB = await database.open('testDB');
            testDB.setString('hello', 'world');
            var name = testDB.getString('hello');
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
            final testDB = await database.open('testDB');
            await testDB.setObject('e', sample.Person(name: '123'));
            var person = await testDB.getObject<sample.Person>('e', () => sample.Person());
            debugPrint('person name: ${person!.name}');
          }),
    ]);
  }
}
