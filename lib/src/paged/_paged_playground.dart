// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/pb.dart' as pb;
import 'package:libcli/storage.dart' as storage;
import 'paged_data_source.dart';
import 'paged_object_source.dart';
import 'paged_table.dart';
import 'paged_list.dart';
import 'types.dart';

int refreshCount = 0;

class PagedPlayground extends StatelessWidget {
  const PagedPlayground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              SizedBox(
                height: 300,
                child: _simpleList(),
              ),
              testing.example(
                context,
                text: 'clear storage',
                child: _clearStorage(),
              ),
              testing.example(
                context,
                text: 'simple table',
                child: _simpleTable(),
              ),
              testing.example(
                context,
                text: 'object table',
                child: _simpleObjectTable(),
              ),
              testing.example(
                context,
                text: 'simple list',
                child: _simpleList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _clearStorage() {
    return ElevatedButton(
      child: const Text('clear storage'),
      onPressed: () async => await storage.clear(),
    );
  }

  Widget _simpleObjectTable() {
    return ChangeNotifierProvider<PagedDataSource>(
      create: (context) => PagedObjectSource<pb.Error>(
        key: 'mySource',
        objectBuilder: () => pb.Error(),
        dataLoader: (BuildContext context, pb.Error? last, int length) async {
          await Future.delayed(const Duration(seconds: 3));
          if (last == null) {
            return List.generate(10, (index) => pb.Error()..code = 'Error $index');
          }
          return List.generate(2, (index) => pb.Error()..code = 'old Error $index');
        },
        dataRefresher: (BuildContext context, pb.Error? first, int rowsPerPage) async {
          await Future.delayed(const Duration(seconds: 2));
          refreshCount++;
          return RefreshInstruction(
            updated: [pb.Error()..code = 'new Error'],
            deleted: [],
          );
        },
        dataRemover: (BuildContext context, List<pb.Error> removeList) async => true,
      )..init(context),
      child: Consumer<PagedDataSource>(
          builder: (context, dataSource, child) => PagedTable<pb.Error>(
                dataSource: dataSource,
                header: Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_outlined),
                      label: const Text('Error'),
                      onPressed: () => debugPrint('clicked'),
                    ),
                  ],
                ),
                actions: const [],
                columns: [
                  DataColumn(label: const Text('code'), onSort: (index, asc) {}),
                  DataColumn(label: const Text('message'), onSort: (index, asc) {}),
                ],
                rowBuilder: (BuildContext context, pb.Error err, int rowIndex) {
                  return [
                    DataCell(
                      Text(err.code),
                      onTap: () => debugPrint('taped'),
                    ),
                    DataCell(
                      ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 250), //SET max width
                          child: Text(err.toDebugString(), overflow: TextOverflow.ellipsis)),
                      onTap: () => debugPrint('taped'),
                    ),
                  ];
                },
                cardHeight: 100,
                cardBuilder: (BuildContext context, pb.Error err, int rowIndex) {
                  return Material(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(err.code),
                    ),
                  );
                },
              )),
    );
  }

  Widget _simpleTable() {
    return ChangeNotifierProvider<PagedDataSource>(
      create: (context) => PagedDataSource<String>(
        dataLoader: (BuildContext context, String? last, int length) async {
          await Future.delayed(const Duration(seconds: 2));
          refreshCount++;
          if (last == null) {
            // init
            return List.generate(10, (index) => 'Item $index');
          }
          // load more data
          return List.generate(2, (index) => 'A $index');
        },
        dataRefresher: (BuildContext context, String? first, int rowsPerPage) async {
          await Future.delayed(const Duration(seconds: 2));
          refreshCount++;
          return RefreshInstruction(
            updated: ['refresh $refreshCount'],
            deleted: ['Item $refreshCount'],
          );
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
        dataRemover: (BuildContext context, List<String> removeList) async => true,
      )..init(context),
      child: Consumer<PagedDataSource>(
          builder: (context, dataSource, child) => PagedTable<String>(
                dataSource: dataSource,
                header: Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add_outlined),
                      label: const Text('Product'),
                      onPressed: () => debugPrint('Received click'),
                    ),
                  ],
                ),
                actions: const [],
                columns: [
                  DataColumn(label: const Text('ID'), onSort: (index, asc) {}),
                  DataColumn(label: const Text('Name'), onSort: (index, asc) {}),
                  DataColumn(label: const Text('Price'), onSort: (index, asc) {}),
                ],
                rowBuilder: (BuildContext context, String row, int rowIndex) {
                  return [
                    DataCell(
                      Text(row),
                      onTap: () => debugPrint('taped'),
                    ),
                    DataCell(
                      ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 250), //SET max width
                          child: const Text('very long text blah blah blah blah blah blah',
                              overflow: TextOverflow.ellipsis)),
                      onTap: () => debugPrint('taped'),
                    ),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: double.infinity,
                          maxWidth: double.infinity,
                        ), //SET max width
                        child: const Text('fit width', overflow: TextOverflow.ellipsis),
                      ),
                      onTap: () => debugPrint('taped'),
                    ),
//          DataCell(Text(rowIndex.toString())),
                  ];
                },
              )),
    );
  }

  Widget _simpleList() {
    return ChangeNotifierProvider<PagedDataSource>(
      create: (context) => PagedDataSource<String>(
        dataLoader: (BuildContext context, String? last, int length) async {
          await Future.delayed(const Duration(seconds: 2));
          refreshCount++;
          if (last == null) {
            // init
            return List.generate(10, (index) => 'Item $index');
          }
          // load more data
          return List.generate(2, (index) => 'A $index');
        },
        dataRefresher: (BuildContext context, String? first, int rowsPerPage) async {
          await Future.delayed(const Duration(seconds: 2));
          refreshCount++;
          return RefreshInstruction(
            updated: ['refresh $refreshCount'],
            deleted: ['Item $refreshCount'],
          );
        },
        dataComparator: (String src, String dest) {
          return src.compareTo(dest);
        },
        dataRemover: (BuildContext context, List<String> removeList) async => true,
      )..init(context),
      child: Consumer<PagedDataSource>(
          builder: (context, dataSource, child) => PagedList<String>(
                dataSource: dataSource,
                cardBuilder: (BuildContext context, String text, int rowIndex) {
                  return Material(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(text),
                    ),
                  );
                },
              )),
    );
  }
}
