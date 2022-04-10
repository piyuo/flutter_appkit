import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/meta/sample/sample.dart' as sample;
import 'package:libcli/animations/animations.dart' as animations;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/unique/unique.dart' as unique;
import '../notes.dart';

enum SampleFilter { inbox, vip, sent, all }

final _searchBoxController = TextEditingController();
int refreshNum = 10; // number that changes when refreshed
Stream<int> counterStream = Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);
int sampleID = 0;
var animationListItems = ['a', 'b', 'c', 'd', 'e'];

main() {
  app.start(
    appName: 'notes',
    providers: [],
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
/*          Consumer<NotesController>(
              builder: (context, viewController, child) => IconButton(
                    icon: const Icon(Icons.pending_outlined),
                    onPressed: () async {
//                      final value = await showMasterDetailMenu(
                      //                      context,
                      //                    viewController: viewController,
                      //                );
                      //              debugPrint('$value just pressed');
                    },
                  )),*/
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _notesView(context),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  testing.ExampleButton(label: 'simple list', builder: () => _simpleList(context)),
                  testing.ExampleButton(label: 'simple grid', builder: () => _simpleGrid(context)),
                  testing.ExampleButton(label: 'checkable grid', builder: () => _checkableGrid(context)),
                  testing.ExampleButton(label: 'checkable list', builder: () => _checkableList(context)),
                  testing.ExampleButton(label: 'dynamic list', builder: () => _dynamicList(context)),
                  testing.ExampleButton(label: 'dynamic grid', builder: () => _dynamicGrid(context)),
                  testing.ExampleButton(label: 'master detail view', builder: () => _masterDetailView(context)),
                  testing.ExampleButton(label: 'notes view', builder: () => _notesView(context)),
                  testing.ExampleButton(label: 'show filter view', builder: () => _showFilterView(context)),
                  testing.ExampleButton(label: 'filter split view', builder: () => _filterSplitView(context)),
                  testing.ExampleButton(label: 'folder view', builder: () => _folderView(context)),
                  testing.ExampleButton(label: 'selection header', builder: () => _selectionHeader(context)),
//                  testing.ExampleButton(label: 'data explorer', builder: () => _tableView(context)),
                  testing.ExampleButton(label: 'loading data', builder: () => _loadingMasterDetailView(context)),
                  testing.ExampleButton(label: 'pull refresh', builder: () => _pullRefresh(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleList(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Expanded(
            child: SimpleList<String>(
              headerBuilder: () => delta.SearchBox(
                controller: _searchBoxController,
              ),
              footerBuilder: () => Container(
                child: const Text('footer'),
                color: Colors.red,
              ),
              items: const ['a', 'b', 'c', 'd', 'e'],
              selectedItems: const ['b'],
              itemBuilder: (String item, bool isSelected) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(item),
              ),
            ),
          ),
        ]));
  }

  Widget _checkableList(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SimpleList<String>(
          headerBuilder: () => delta.SearchBox(
            controller: _searchBoxController,
          ),
          checkMode: true,
          items: const ['a', 'b', 'c', 'd', 'e'],
          selectedItems: const ['b'],
          itemBuilder: (String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(item),
          ),
        ),
      ),
    ]);
  }

  Widget _simpleGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SimpleGrid<String>(
        crossAxisCount: 2,
        headerBuilder: () => delta.SearchBox(
          controller: _searchBoxController,
        ),
        items: const ['a', 'b', 'c', 'd', 'e'],
        selectedItems: const ['b'],
        itemBuilder: (String item, bool isSelected) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(item),
        ),
        labelBuilder: (String item, bool isSelected) => Container(
          color: Colors.yellow,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: const Center(child: Text('hello world')),
        ),
      ),
    );
  }

  Widget _checkableGrid(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SimpleGrid<String>(
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
          itemBuilder: (String item, bool isSelected) => Padding(
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

  Widget _dynamicList(BuildContext context) {
    return ChangeNotifierProvider<animations.AnimatedViewProvider>(
        create: (context) => animations.AnimatedViewProvider(animationListItems.length),
        child: Consumer<animations.AnimatedViewProvider>(
            builder: (context, provide, child) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  OutlinedButton(
                    child: const Text('insert'),
                    onPressed: () {
                      animationListItems.insert(0, 'z');
                      provide.insertAnimation();
                    },
                  ),
                  Expanded(
                    child: DynamicList<String>(
                      headerBuilder: () => delta.SearchBox(
                        controller: _searchBoxController,
                      ),
                      footerBuilder: () => Container(
                        child: const Text('footer'),
                        color: Colors.red,
                      ),
                      items: animationListItems,
                      selectedItems: const ['b'],
                      itemBuilder: (String item, bool isSelected) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(item),
                      ),
                    ),
                  ),
                ]))));
  }

  Widget _pullRefresh(BuildContext context) {
    return ChangeNotifierProvider<animations.AnimatedViewProvider>(
        create: (context) => animations.AnimatedViewProvider(15),
        child: Consumer<animations.AnimatedViewProvider>(
            builder: (context, provide, child) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                      child: DynamicList<String>(
                    items: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'],
                    selectedItems: const ['b'],
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 3));
                      debugPrint('refresh');
                    },
                    onLoadMore: () async {
                      await Future.delayed(const Duration(seconds: 3));
                      debugPrint('load more');
                    },
                    itemBuilder: (String item, bool isSelected) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Text(item),
                    ),
                  )),
                ]))));
  }

  Widget _dynamicGrid(BuildContext context) {
    return ChangeNotifierProvider<animations.AnimatedViewProvider>(
        create: (context) => animations.AnimatedViewProvider(animationListItems.length),
        child: Consumer<animations.AnimatedViewProvider>(
            builder: (context, provide, child) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  OutlinedButton(
                    child: const Text('insert'),
                    onPressed: () {
                      animationListItems.insert(0, 'z');
                      provide.insertAnimation();
                    },
                  ),
                  Expanded(
                    child: DynamicGrid<String>(
                      headerBuilder: () => delta.SearchBox(
                        controller: _searchBoxController,
                      ),
                      footerBuilder: () => Container(
                        child: const Text('footer'),
                        color: Colors.red,
                      ),
                      items: animationListItems,
                      selectedItems: const ['b'],
                      itemBuilder: (String item, bool isSelected) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(item),
                      ),
                    ),
                  ),
                ]))));
  }

  Widget _masterDetailView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<animations.AnimatedViewProvider>(
            create: (context) => animations.AnimatedViewProvider(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer<_SelectedController>(
            builder: (context, selectedController, child) => MasterDetailView<String>(
                  headerBuilder: () => delta.SearchBox(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => showTagView<SampleFilter>(
                        context,
                        onTagSelected: (value) => debugPrint('$value selected'),
                        tags: const [
                          Tag<SampleFilter>(
                            label: 'Inbox',
                            value: SampleFilter.inbox,
                            icon: Icons.inbox,
                            count: 0,
                          ),
                          Tag<SampleFilter>(
                            label: 'VIPs',
                            value: SampleFilter.vip,
                            icon: Icons.verified_user,
                            count: 1,
                            selected: true,
                          ),
                          Tag<SampleFilter>(
                            label: 'Sent',
                            value: SampleFilter.sent,
                            icon: Icons.send,
                            count: 20,
                          ),
                          Tag<SampleFilter>(
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
                  information: '1-6 of 6',
                  items: const ['a', 'b', 'c', 'd', 'e'],
                  selectedItems: const ['a'],
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
                )));
  }

/*
  Widget _tableView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SampleTable>(create: (context) => SampleTable(context)),
        ],
        child: Consumer<SampleTable>(
            builder: (context, table, _) => TableView<sample.Person>(
                  table: table,
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
                  onShowDetail: (sample.Person person) => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Scaffold(
                      appBar: AppBar(
                        elevation: 1,
                      ),
                      body: SafeArea(
                          child: Column(
                        children: [
                          Text('name:${person.name}'),
                          Text('age:${person.age}'),
                        ],
                      )),
                    );
                  })),
                  onBarAction: (action) async {},
                )));
  }
*/

  Widget _showFilterView(BuildContext context) {
    return OutlinedButton(
      child: const Text('show folder view'),
      onPressed: () => showTagView<SampleFilter>(
        context,
        onTagSelected: (value) => debugPrint('$value selected'),
        tags: const [
          Tag<SampleFilter>(
            label: 'Inbox',
            value: SampleFilter.inbox,
            icon: Icons.inbox,
            count: 0,
          ),
          Tag<SampleFilter>(
            label: 'VIPs',
            value: SampleFilter.vip,
            icon: Icons.verified_user,
            count: 1,
            selected: true,
          ),
          Tag<SampleFilter>(
            label: 'Sent',
            value: SampleFilter.sent,
            icon: Icons.send,
            count: 20,
          ),
          Tag<SampleFilter>(
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
    return TagView<SampleFilter>(
      onTagSelected: (value) => debugPrint('$value selected'),
      tags: const [
        Tag<SampleFilter>(
          label: 'Inbox',
          value: SampleFilter.inbox,
          icon: Icons.inbox,
          count: 0,
        ),
        Tag<SampleFilter>(
          label: 'VIPs',
          value: SampleFilter.vip,
          icon: Icons.verified_user,
          count: 1,
          selected: true,
        ),
        Tag<SampleFilter>(
          label: 'Sent',
          value: SampleFilter.sent,
          icon: Icons.send,
          count: 20,
        ),
        Tag<SampleFilter>(
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
          ChangeNotifierProvider<animations.AnimatedViewProvider>(
            create: (context) => animations.AnimatedViewProvider(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer<_SelectedController>(
          builder: (context, selectedController, child) => TagSplitView(
              tagView: TagView<SampleFilter>(
                onTagSelected: (value) => debugPrint('$value selected'),
                tags: const [
                  Tag<SampleFilter>(
                    label: 'Inbox',
                    value: SampleFilter.inbox,
                    icon: Icons.inbox,
                    count: 0,
                  ),
                  Tag<SampleFilter>(
                    label: 'VIPs',
                    value: SampleFilter.vip,
                    icon: Icons.verified_user,
                    count: 1,
                    selected: true,
                  ),
                  Tag<SampleFilter>(
                    label: 'Sent',
                    value: SampleFilter.sent,
                    icon: Icons.send,
                    count: 20,
                  ),
                  Tag<SampleFilter>(
                    label: 'All',
                    value: SampleFilter.all,
                    icon: Icons.all_inbox,
                    count: 120,
                    category: 'iCloud',
                  ),
                ],
              ),
              child: MasterDetailView<String>(
                information: '1-6 of 6',
                items: const ['a', 'b', 'c', 'd', 'e'],
                selectedItems: const ['a'],
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
              )),
        ));
  }

  Widget _selectionHeader(BuildContext context) {
    return Column(children: [
      CheckableHeader(
        onSelectAll: () => debugPrint('select all'),
        onUnselectAll: () => debugPrint('unselect all'),
        selectedItemCount: 12,
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
      const CheckableHeader(
        selectedItemCount: 3,
        isAllSelected: true,
      ),
    ]);
  }

  Widget _loadingMasterDetailView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
//          ChangeNotifierProvider<NotesController>(
          //          create: (context) => NotesController(),
          //      )
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

  Widget _notesView(BuildContext context) {
    int stepCount = 0;
    return ChangeNotifierProvider<NotesController<sample.Person>>(
        create: (context) => NotesController<sample.Person>(
              db.MemoryRam(dataBuilder: () => sample.Person()),
              context: context,
              loader: (context, isRefresh, limit, anchorTimestamp, anchorId) async {
                stepCount++;
                return List.generate(
                  stepCount == 1 ? 10 : 2,
                  (i) {
                    final uuid = unique.uuid();
                    return sample.Person(
                      name: uuid,
                      entity: pb.Entity(id: uuid),
                    );
                  },
                );
              },
              dataBuilder: () => sample.Person(),
              tags: const [
                Tag(
                  label: 'Inbox',
                  value: 'inbox',
                  icon: Icons.inbox,
                  count: 0,
                ),
                Tag(
                  label: 'VIPs',
                  value: 'vips',
                  icon: Icons.verified_user,
                  count: 1,
                  selected: true,
                ),
                Tag(
                  label: 'Sent',
                  value: 'sent',
                  icon: Icons.send,
                  count: 20,
                ),
                Tag(
                  label: 'All',
                  value: 'all',
                  icon: Icons.all_inbox,
                  count: 120,
                  category: 'iCloud',
                ),
              ],
            ),
        child: Consumer<NotesController<sample.Person>>(
          builder: (context, notesController, child) => NotesView<sample.Person>(
            controller: notesController,
            listBuilder: (sample.Person person, bool isSelected) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text('list:${person.name}'),
            ),
            gridBuilder: (sample.Person person, bool isSelected) => Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
              child: Text('grid:$person'),
            ),
            labelBuilder: (sample.Person person, bool isSelected) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Center(child: Text('hello world', style: TextStyle(color: Colors.red))),
            ),
            detailBuilder: (sample.Person person) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Center(child: Text('detail view for $person')),
            ),
            onBarAction: (action) async {
              debugPrint('$action pressed');
              if (action == MasterDetailViewAction.refresh) {
                await Future.delayed(const Duration(seconds: 10));
              }
            },
          ),
        ));
  }
}
