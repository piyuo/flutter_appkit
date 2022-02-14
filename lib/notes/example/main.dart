import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/unique/unique.dart' as unique;
import '../notes.dart';

enum SampleFilter { inbox, vip, sent, all }

final _searchBoxController = TextEditingController();
int refreshNum = 10; // number that changes when refreshed
Stream<int> counterStream = Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);
main() {
  app.start(
    appName: 'notes',
    providers: [
      ChangeNotifierProvider<ViewController>(
        create: (context) => ViewController(),
      ),
    ],
    routes: {
      '/': (context, state, data) => const NotesExample(),
    },
  );
}

class _SelectedController with ChangeNotifier {
  List<String> _items = [];

  List<String> get items => _items;

  set items(items) {
    _items = items;
    notifyListeners();
  }
}

class NotesExample extends StatelessWidget {
  const NotesExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Notes'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        actions: [
          Consumer<ViewController>(
              builder: (context, viewController, child) => IconButton(
                    icon: const Icon(Icons.pending_outlined),
                    onPressed: () async {
                      final value = await showMasterDetailMenu(
                        context,
                        viewController: viewController,
                      );
                      debugPrint('$value just pressed');
                    },
                  )),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _masterDetailView(context),
            ),
            Wrap(
              children: [
                testing.ExampleButton(label: 'show filter view', builder: () => _showFilterView(context)),
                testing.ExampleButton(label: 'filter split view', builder: () => _filterSplitView(context)),
                testing.ExampleButton(label: 'folder view', builder: () => _folderView(context)),
                testing.ExampleButton(label: 'selection header', builder: () => _selectionHeader(context)),
                testing.ExampleButton(label: 'data explorer', builder: () => _dataExplorer(context)),
                testing.ExampleButton(label: 'loading data', builder: () => _loadingMasterDetailView(context)),
                testing.ExampleButton(label: 'master detail view', builder: () => _masterDetailView(context)),
                testing.ExampleButton(label: 'selectable grid', builder: () => _selectableGrid(context)),
                testing.ExampleButton(label: 'checkable grid', builder: () => _checkableGrid(context)),
                testing.ExampleButton(label: 'selectable list', builder: () => _selectableList(context)),
                testing.ExampleButton(label: 'checkable list', builder: () => _checkableList(context)),
                testing.ExampleButton(label: 'list gallery', builder: () => _selectableList(context)),
                testing.ExampleButton(label: 'pull refresh', builder: () => _pullRefresh(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataExplorer(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<data.DataSource<sample.Person>>(
              create: (context) => data.DataSource<sample.Person>(
                    context: context,
                    autoSelectFirstRow: true,
                    id: 'today_customer',
                    dataBuilder: () => sample.Person(),
                    dataRemover: (BuildContext context, List<String> ids) async => true,
                    dataLoader: (BuildContext context, isRefresh, limit, anchorTimestamp, anchorId) async {
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
                  )),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<ViewController>(
            create: (context) => ViewController(),
          )
        ],
        child: Consumer<data.DataSource<sample.Person>>(
            builder: (context, dataSource, _) => DataExplorer<sample.Person>(
                  dataSource: dataSource,
                  listBuilder: (sample.Person person, bool isSelected) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('list:${person.name}'),
                  ),
                  gridBuilder: (sample.Person person, bool isSelected) => Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text('list:${person.name}'),
                  ),
                  labelBuilder: (sample.Person person, bool isSelected) => Text('label:${person.age}'),
                  detailBuilder: (sample.Person person) => Column(
                    children: [
                      Text('name:${person.name}'),
                      Text('age:${person.age}'),
                    ],
                  ),
                  onAction: (action) async {},
                )));
  }

  Widget _masterDetailView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, ViewController>(
            builder: (context, selectedController, viewController, child) => MasterDetailView<String>(
                  headerBuilder: () => delta.SearchBox(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => showFilterView<SampleFilter>(
                        context,
                        onFilterSelected: (value) => debugPrint('$value selected'),
                        filters: const [
                          Filter<SampleFilter>(
                            label: 'Inbox',
                            value: SampleFilter.inbox,
                            icon: Icons.inbox,
                            count: 0,
                          ),
                          Filter<SampleFilter>(
                            label: 'VIPs',
                            value: SampleFilter.vip,
                            icon: Icons.verified_user,
                            count: 1,
                            selected: true,
                          ),
                          Filter<SampleFilter>(
                            label: 'Sent',
                            value: SampleFilter.sent,
                            icon: Icons.send,
                            count: 20,
                          ),
                          Filter<SampleFilter>(
                            label: 'All',
                            value: SampleFilter.all,
                            icon: Icons.all_inbox,
                            count: 120,
                            category: 'iCloud',
                          ),
                        ],
                      ),
                    ),
                    controller: _searchBoxController,
                  ),
                  pageInfo: '1-6 of 6',
                  items: const ['a', 'b', 'c', 'd', 'e'],
                  selectedItems: viewController.isSelecting
                      ? selectedController.items
                      : selectedController.items.isEmpty
                          ? ['a']
                          : selectedController.items,
                  listBuilder: (String item, bool isSelected) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text('list:' + item),
                  ),
                  gridBuilder: (String item, bool isSelected) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                    child: Text('grid:' + item),
                  ),
                  labelBuilder: (String item, bool isSelected) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Center(child: Text('hello world', style: TextStyle(color: Colors.red))),
                  ),
                  detailBuilder: (String item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Center(child: Text('detail view for $item')),
                  ),
                  onBarAction: (action) async {
                    debugPrint('$action pressed');
                    if (action == MasterDetailViewAction.refresh) {
                      await Future.delayed(const Duration(seconds: 10));
                    }
                  },
                  onItemSelected: (items) {
                    selectedController.items = items;
                  },
                  onItemChecked: (items) {
                    selectedController.items = items;
                  },
                  onCheckBegin: () => selectedController.items = <String>[],
                  onCheckEnd: () => selectedController.items = <String>['a'],
                  onRefresh: () async => debugPrint('refresh'),
                  onLoadMore: () async => debugPrint('load more'),
                )));
  }

  Widget _showFilterView(BuildContext context) {
    return OutlinedButton(
      child: const Text('show folder view'),
      onPressed: () => showFilterView<SampleFilter>(
        context,
        onFilterSelected: (value) => debugPrint('$value selected'),
        filters: const [
          Filter<SampleFilter>(
            label: 'Inbox',
            value: SampleFilter.inbox,
            icon: Icons.inbox,
            count: 0,
          ),
          Filter<SampleFilter>(
            label: 'VIPs',
            value: SampleFilter.vip,
            icon: Icons.verified_user,
            count: 1,
            selected: true,
          ),
          Filter<SampleFilter>(
            label: 'Sent',
            value: SampleFilter.sent,
            icon: Icons.send,
            count: 20,
          ),
          Filter<SampleFilter>(
            label: 'All',
            value: SampleFilter.all,
            icon: Icons.all_inbox,
            count: 120,
            category: 'iCloud',
          ),
        ],
      ),
    );
  }

  Widget _folderView(BuildContext context) {
    return FilterView<SampleFilter>(
      onFilterSelected: (value) => debugPrint('$value selected'),
      filters: const [
        Filter<SampleFilter>(
          label: 'Inbox',
          value: SampleFilter.inbox,
          icon: Icons.inbox,
          count: 0,
        ),
        Filter<SampleFilter>(
          label: 'VIPs',
          value: SampleFilter.vip,
          icon: Icons.verified_user,
          count: 1,
          selected: true,
        ),
        Filter<SampleFilter>(
          label: 'Sent',
          value: SampleFilter.sent,
          icon: Icons.send,
          count: 20,
        ),
        Filter<SampleFilter>(
          label: 'All',
          value: SampleFilter.all,
          icon: Icons.all_inbox,
          count: 120,
          category: 'iCloud',
        ),
      ],
    );
  }

  Widget _filterSplitView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, ViewController>(
          builder: (context, selectedController, viewController, child) => FilterSplitView(
              folderView: FilterView<SampleFilter>(
                onFilterSelected: (value) => debugPrint('$value selected'),
                filters: const [
                  Filter<SampleFilter>(
                    label: 'Inbox',
                    value: SampleFilter.inbox,
                    icon: Icons.inbox,
                    count: 0,
                  ),
                  Filter<SampleFilter>(
                    label: 'VIPs',
                    value: SampleFilter.vip,
                    icon: Icons.verified_user,
                    count: 1,
                    selected: true,
                  ),
                  Filter<SampleFilter>(
                    label: 'Sent',
                    value: SampleFilter.sent,
                    icon: Icons.send,
                    count: 20,
                  ),
                  Filter<SampleFilter>(
                    label: 'All',
                    value: SampleFilter.all,
                    icon: Icons.all_inbox,
                    count: 120,
                    category: 'iCloud',
                  ),
                ],
              ),
              child: MasterDetailView<String>(
                pageInfo: '1-6 of 6',
                items: const ['a', 'b', 'c', 'd', 'e'],
                selectedItems: viewController.isSelecting
                    ? selectedController.items
                    : selectedController.items.isEmpty
                        ? ['a']
                        : selectedController.items,
                listBuilder: (String item, bool isSelected) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text('list:' + item),
                ),
                gridBuilder: (String item, bool isSelected) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                  child: Text('grid:' + item),
                ),
                labelBuilder: (String item, bool isSelected) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Center(child: Text('hello world', style: TextStyle(color: Colors.red))),
                ),
                detailBuilder: (String item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Center(child: Text('detail view for $item')),
                ),
                onBarAction: (action) async {
                  debugPrint('$action pressed');
                  if (action == MasterDetailViewAction.refresh) {
                    await Future.delayed(const Duration(seconds: 10));
                  }
                },
                onItemSelected: (items) {
                  selectedController.items = items;
                },
                onItemChecked: (items) {
                  selectedController.items = items;
                },
                onCheckBegin: () => selectedController.items = <String>[],
                onCheckEnd: () => selectedController.items = <String>['a'],
              )),
        ));
  }

  Widget _selectionHeader(BuildContext context) {
    return Column(children: [
      SelectionHeader(
        onSelectAll: () => debugPrint('select all'),
        onUnselectAll: () => debugPrint('unselect all'),
        selected: 12,
        isAllSelected: true,
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.grey.shade900,
            ),
            label: const Text('Archive'),
            icon: const Icon(Icons.archive),
            onPressed: () {},
          ),
          SizedBox(height: 20, child: VerticalDivider(width: 5, color: Colors.grey.shade900)),
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.grey.shade900,
            ),
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      const SizedBox(height: 20),
      const SelectionHeader(
        selected: 3,
        isAllSelected: true,
        showCheckbox: false,
      ),
    ]);
  }

  Widget _loadingMasterDetailView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<ViewController>(
            create: (context) => ViewController(),
          )
        ],
        child: MasterDetailView<String>(
          isLoading: true,
          items: const [],
          selectedItems: const [],
          listBuilder: (String item, bool isSelected) => const SizedBox(),
          gridBuilder: (String item, bool isSelected) => const SizedBox(),
          labelBuilder: (String item, bool isSelected) => const Text('label'),
          detailBuilder: (String item) => const Text('detail view'),
          onBarAction: (action) async => debugPrint('$action pressed'),
        ));
  }

  Widget _selectableGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SelectableGrid<String>(
        gap: 50,
        headerBuilder: () => delta.SearchBox(
          controller: _searchBoxController,
        ),
        items: const ['a', 'b', 'c', 'd', 'e'],
        selectedItems: const ['b'],
        builder: (String item, bool isSelected) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(item),
        ),
        labelBuilder: (String item, bool isSelected) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Center(child: Text('hello world')),
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
          debugPrint('refresh');
        },
        onLoadMore: () async {
          await Future.delayed(const Duration(seconds: 3));
          debugPrint('load more');
        },
      ),
    );
  }

  Widget _checkableGrid(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SelectableGrid<String>(
          headerBuilder: () => delta.SearchBox(
            controller: _searchBoxController,
          ),
          footerBuilder: () => Container(
            child: const Text('footer'),
            color: Colors.red,
          ),
          checkMode: true,
          items: const ['a', 'b', 'c', 'd', 'e'],
          selectedItems: const ['b'],
          builder: (String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Text(item),
          ),
          labelBuilder: (String item, bool isSelected) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Center(child: Text('hello world')),
          ),
        ),
      ),
    ]);
  }

  Widget _selectableList(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SelectableList<String>(
          headerBuilder: () => delta.SearchBox(
            controller: _searchBoxController,
          ),
          footerBuilder: () => Container(
            child: const Text('footer'),
            color: Colors.red,
          ),
          items: const ['a', 'b', 'c', 'd', 'e'],
          selectedItems: const ['b'],
          builder: (String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(item),
          ),
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 3));
            debugPrint('refresh');
          },
          onLoadMore: () async {
            await Future.delayed(const Duration(seconds: 3));
            debugPrint('load more');
          },
        ),
      ),
    ]);
  }

  Widget _checkableList(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SelectableList<String>(
          headerBuilder: () => delta.SearchBox(
            controller: _searchBoxController,
          ),
          checkMode: true,
          items: const ['a', 'b', 'c', 'd', 'e'],
          selectedItems: const ['b'],
          builder: (String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(item),
          ),
        ),
      ),
    ]);
  }

  Widget _pullRefresh(BuildContext context) {
    return Column(children: [
      Expanded(
          child: SelectableList<String>(
        items: const ['a', 'b', 'c', 'd', 'e', 'a', 'b', 'c', 'd', 'e', 'a', 'b', 'c', 'd', 'e'],
        selectedItems: const ['b'],
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
          debugPrint('refresh');
        },
        onLoadMore: () async {
          await Future.delayed(const Duration(seconds: 3));
          debugPrint('load more');
        },
        builder: (String item, bool isSelected) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(item),
        ),
      )),
    ]);
  }
}
