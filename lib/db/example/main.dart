import 'package:libcli/pb/pb.dart' as pb;
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../db.dart';
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
  init();
  registerBuilder((id, bytes) {
    return pb.Error.fromBuffer(bytes);
  });
  app.start(
    appName: 'db',
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
          testing.example(
            context,
            text: 'padding to tablet',
            child: _sample(context),
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
            final testDB = await use('testDB');
            testDB.set('hello', 'world');
            var name = testDB.get('hello');
            debugPrint('hello:$name');
          }),
      OutlinedButton(
          child: const Text('custom type'),
          onPressed: () async {
            final testDB = await use('testDB');
            testDB.set(
                'i',
                Inventory(
                  name: 'name',
                  description: 'description',
                ));
            var inventory = await testDB.get('i');
            debugPrint('Name: ${inventory.name}');
          }),
      OutlinedButton(
          child: const Text('pb.Object'),
          onPressed: () async {
            final testDB = await use('testDB');
            testDB.set('e', pb.Error()..code = '123');
            var err = await testDB.get('e');
            debugPrint('error code: ${err.code}');
          }),
    ]);
  }
}
