// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/unique/unique.dart' as unique;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/pb/src/google/google.dart' as google;
import '../data.dart';

main() => app.start(
      appName: 'data',
      objectBuilders: {'sample': sample.objectBuilder},
      routes: {
        '/': (context, state, data) => const DataExample(),
      },
    );

int refreshCount = 0;

class DataExample extends StatelessWidget {
  const DataExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: _emptyPullList(),
        ),
        Wrap(
          children: [
            testing.example(
              context,
              text: 'page table',
              useScaffold: false,
              child: _pageTable(),
            ),
            testing.example(
              context,
              text: 'empty table',
              useScaffold: false,
              child: _emptyTable(),
            ),
            testing.example(
              context,
              text: 'pull list',
              useScaffold: false,
              child: _pullList(),
            ),
            testing.example(
              context,
              text: 'empty pull list',
              useScaffold: false,
              child: _emptyPullList(),
            ),
            testing.example(
              context,
              text: 'utility',
              child: _utility(),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _utility() {
    return Wrap(
      children: [
        OutlinedButton(
          child: const Text('clear cache'),
          onPressed: () async => await cache.reset(),
        ),
        OutlinedButton(
          child: const Text('set 50 item'),
          onPressed: () async {
            final now = DateTime.now();
            for (int i = 0; i < 50; i++) {
              await cache.set(
                  'key$i',
                  sample.Person(
                    entity: pb.Entity(
                      id: unique.uuid(),
                      updateTime: DateTime.now().utcTimestamp,
                      notGoingToChange: false,
                      deleted: false,
                    ),
                    name: 'stress test $i',
                    age: i,
                  ));
            }
            debugPrint('set 50 item: ${DateTime.now().difference(now).inMilliseconds}ms');
          },
        ),
        OutlinedButton(
          child: const Text('update 50 item'),
          onPressed: () async {
            final now = DateTime.now();
            for (int i = 0; i < 50; i++) {
              await cache.set(
                  'key$i',
                  sample.Person(
                    entity: pb.Entity(
                      id: unique.uuid(),
                      updateTime: DateTime.now().utcTimestamp,
                      notGoingToChange: true,
                      deleted: true,
                    ),
                    name: 'update test $i',
                    age: i,
                  ));
            }
            debugPrint('update 50 item: ${DateTime.now().difference(now).inMilliseconds}ms');
          },
        ),
        OutlinedButton(
          child: const Text('delete 50 item'),
          onPressed: () async {
            final now = DateTime.now();
            for (int i = 0; i < 50; i++) {
              await cache.delete(
                'key$i',
              );
            }
            debugPrint('delete 50 item: ${DateTime.now().difference(now).inMilliseconds}ms');
          },
        ),
      ],
    );
  }

  Widget _emptyTable() {
    return ChangeNotifierProvider<DataSource<sample.Person>>(
      create: (context) => DataSource<sample.Person>(
        context: context,
        id: 'data.example.empty_table',
        dataLoader: (
          BuildContext context, {
          required bool isRefresh,
          required int limit,
          google.Timestamp? anchorTimestamp,
          String? anchorId,
        }) async =>
            [],
      ),
      child: Consumer<DataSource<sample.Person>>(
          builder: (context, dataSource, child) => PageTable<sample.Person>(
                dataSource: dataSource,
                columns: [
                  PageColumn(label: const Text('ID')),
                  PageColumn(label: const Text('Name'), width: ColumnWidth.large),
                  PageColumn(label: const Text('Age'), width: ColumnWidth.small),
                ],
                tableBuilder: (BuildContext context, sample.Person person, int rowIndex) => [],
                cardBuilder: (BuildContext context, sample.Person person, int rowIndex) => const SizedBox(),
              )),
    );
  }

  Widget _pageTable() {
    return ChangeNotifierProvider<DataSource<sample.Person>>(
      create: (context) => DataSource<sample.Person>(
        context: context,
        id: 'today_customer',
        dataLoader: (BuildContext context,
            {required bool isRefresh, required int limit, google.Timestamp? anchorTimestamp, String? anchorId}) async {
          await Future.delayed(const Duration(seconds: 1));
          if (isRefresh) {
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: unique.uuid(),
                        updateTime: DateTime.now().utcTimestamp,
                        notGoingToChange: false,
                        deleted: false,
                      ),
                      name: 'refresh $index',
                      age: index,
                    ));
          }
          refreshCount++;
          if (refreshCount > 2) {
            refreshCount = 0;
            return [];
          }

          // load more data
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: unique.uuid(),
                      updateTime: DateTime.now().utcTimestamp,
                      notGoingToChange: false,
                      deleted: false,
                    ),
                    name: 'more $index',
                    age: index,
                  ));
        },
      ),
      child: Consumer<DataSource<sample.Person>>(
          builder: (context, dataSource, child) => PageTable<sample.Person>(
                dataSource: dataSource,
                smallRatio: 0.25,
                largeRatio: 3,
                columns: [
                  PageColumn(label: const Text('ID')),
                  PageColumn(label: const Text('Name'), width: ColumnWidth.large),
                  PageColumn(label: const Text('Age'), width: ColumnWidth.small),
                ],
                dataRemover: (BuildContext context, List<sample.Person> removeList) async => true,
                tableBuilder: (BuildContext context, sample.Person person, int rowIndex) {
                  return [
                    Text(person.entityId, overflow: TextOverflow.ellipsis),
                    Text('${person.name} very long text blah blah blah blah blah blah',
                        overflow: TextOverflow.ellipsis),
                    Text('${person.age}', overflow: TextOverflow.ellipsis),
                  ];
                },
                cardBuilder: (BuildContext context, sample.Person person, int rowIndex) {
                  return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text(person.entityId),
                        Text(person.name),
                        Text('${person.age}'),
                      ]));
                },
                onRowTap: (BuildContext context, sample.Person person, int rowIndex) => debugPrint(person.name),
              )),
    );
  }

  Widget _pullList() {
    return ChangeNotifierProvider<DataSource<sample.Person>>(
      create: (context) => DataSource<sample.Person>(
        context: context,
        id: 'today_visitor',
        dataLoader: (BuildContext context,
            {required bool isRefresh, required int limit, google.Timestamp? anchorTimestamp, String? anchorId}) async {
          await Future.delayed(const Duration(seconds: 1));
          if (isRefresh) {
            return List.generate(
                limit,
                (index) => sample.Person(
                      entity: pb.Entity(
                        id: unique.uuid(),
                        updateTime: DateTime.now().utcTimestamp,
                        notGoingToChange: false,
                        deleted: false,
                      ),
                      name: 'refresh $index',
                      age: index,
                    ));
          }
          refreshCount++;
          if (refreshCount > 2) {
            refreshCount = 0;
            return [];
          }

          // load more data
          return List.generate(
              limit,
              (index) => sample.Person(
                    entity: pb.Entity(
                      id: unique.uuid(),
                      updateTime: DateTime.now().utcTimestamp,
                      notGoingToChange: false,
                      deleted: false,
                    ),
                    name: 'more $index',
                    age: index,
                  ));
        },
      ),
      child: Consumer<DataSource<sample.Person>>(
          builder: (context, dataSource, child) => PullList<sample.Person>(
                dataSource: dataSource,
                cardBuilder: (BuildContext context, sample.Person person, int rowIndex) {
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text(person.entityId),
                        Text(person.name),
                        Text('${person.age}'),
                      ]));
                },
              )),
    );
  }

  Widget _emptyPullList() {
    return ChangeNotifierProvider<DataSource<sample.Person>>(
      create: (context) => DataSource<sample.Person>(
        context: context,
        id: 'today_visitor_empty',
        dataLoader: (BuildContext context,
            {required bool isRefresh, required int limit, google.Timestamp? anchorTimestamp, String? anchorId}) async {
          await Future.delayed(const Duration(seconds: 1));
          debugPrint('isRefresh: $isRefresh');
          return [];
        },
      ),
      child: Consumer<DataSource<sample.Person>>(
          builder: (context, dataSource, child) => PullList<sample.Person>(
                dataSource: dataSource,
                cardBuilder: (BuildContext context, sample.Person person, int rowIndex) {
                  return Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text(person.entityId),
                      ]));
                },
              )),
    );
  }
}
