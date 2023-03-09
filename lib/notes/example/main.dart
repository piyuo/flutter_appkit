// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/animate_view/animate_view.dart' as animate_view;
import 'package:libcli/data/data.dart' as data;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/generator/generator.dart' as generator;
import '../notes.dart';

enum SampleFilter { inbox, vip, sent, all }

final _searchBoxController = TextEditingController();
int refreshNum = 10; // number that changes when refreshed
Stream<int> counterStream = Stream<int>.periodic(const Duration(seconds: 3), (x) => refreshNum);
int sampleID = 0;
var animationListItems = ['a', 'b', 'c', 'd', 'e'];
int stepCount = 0;

final formGroup = fb.group({
  'name': [Validators.required],
  'age': FormControl<int>(),
});

animate_view.AnimateViewProvider _animateViewProvider = animate_view.AnimateViewProvider()..setLength(5);

NotesProvider<sample.Person> _notesProvider = NotesProvider<sample.Person>(
  animateViewProvider: _animateViewProvider,
  caption: "Notes",
  formController: createFormController(),
  listBuilder: (sample.Person person, bool isSelected) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    child: Text('list:$person'),
  ),
  gridBuilder: (sample.Person person, bool isSelected) => Container(
    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
    child: Text('grid:$person'),
  ),
  //         detailBeamName: "/",
  loader: (isRefresh, limit, anchorTimestamp, anchorId) async {
    if (stepCount == 0) {
      stepCount++;
      return [];
    }
    stepCount++;
    return List.generate(
      stepCount == 1 ? 1 : 1,
      (i) {
        final uuid = generator.randomNumber(6);
        return sample.Person(name: uuid);
      },
    );
  },
  onSearch: (text) => debugPrint('search:$text'),
  onSearchBegin: () => debugPrint('search begin'),
  onSearchEnd: () => debugPrint('search end'),
  tags: [
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
);

/// build note form controller
NoteFormController<sample.Person> createFormController() => NoteFormController<sample.Person>(
      formGroup: formGroup,
      showDeleteButton: true,
      loader: (id) async => sample.Person(name: id)..id = id,
      saver: (persons) async {
        await Future.delayed(const Duration(seconds: 3));
      },
      formBuilder: (context, controller) => delta.Mounted(
        builder: (context, isMounted) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Text('beam: detail view for ${formGroup.value}'),
              ReactiveTextField(
                formControlName: 'name',
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  hintText: 'please input your name',
                ),
                validationMessages: {
                  ValidationMessage.required: (error) => 'The name must not be empty',
                },
              ),
              OutlinedButton(
                onPressed: controller.isAllowDelete
                    ? () async {
                        await controller.delete(context);
                        final mounted = isMounted();
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: const Text('delete'),
              ),
            ])),
      ),
      creator: () async {
        final no = generator.randomNumber(6);
        return sample.Person(name: 'new person $no');
      },
    );
main() {
  app.start(
    title: 'notes example',
    routes: {
      '/': (context, state, _) => const NotesExample(),
      '/:id': (context, state, _) {
        final id = state.pathParameters['id']!;
        return BeamPage(
          key: ValueKey(id),
          title: 'Detail',
          child: _noteItem(context, id),
        );
      },
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
        title: const Text('Example Application'),
        actions: [
          NotesViewMenuButton<sample.Person>(
            viewProvider: _notesProvider,
            formController: _notesProvider.formController,
            tools: [
              responsive.ToolButton(
                label: 'hello',
                icon: Icons.favorite,
                onPressed: () => debugPrint('hello'),
              ),
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _simpleGrid(context),
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
                  OutlinedButton(
                      child: const Text('scroll to top'),
                      onPressed: () => NotesProvider.of<sample.Person>(context).scrollToTop()),
                  testing.ExampleButton(label: 'show filter view', builder: () => _showFilterView(context)),
                  testing.ExampleButton(label: 'filter split view', builder: () => _filterSplitView(context)),
                  testing.ExampleButton(label: 'tag view', builder: () => _tagView(context)),
                  testing.ExampleButton(label: 'selection header', builder: () => _selectionHeader(context)),
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
                color: Colors.red,
                child: const Text('footer'),
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
/*        headerBuilder: () => delta.SearchBox(
          controller: _searchBoxController,
        ),*/
        items: const ['a', 'b', 'c', 'd', 'e'],
        selectedItems: const ['b'],
        itemBuilder: (String item, bool isSelected) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Text(item),
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
            color: Colors.red,
            child: const Text('footer'),
          ),
          checkMode: true,
          items: const ['a', 'b', 'c', 'd', 'e'],
          selectedItems: const ['b'],
          itemBuilder: (String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Text(item),
          ),
        ),
      ),
    ]);
  }

  Widget _dynamicList(BuildContext context) {
    return ChangeNotifierProvider<animate_view.AnimateViewProvider>(
        create: (context) => animate_view.AnimateViewProvider()..setLength(animationListItems.length),
        child: Consumer<animate_view.AnimateViewProvider>(
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
                      animateViewProvider: provide,
                      headerBuilder: () => delta.SearchBox(
                        controller: _searchBoxController,
                      ),
                      footerBuilder: () => Container(
                        color: Colors.red,
                        child: const Text('footer'),
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
    return ChangeNotifierProvider<animate_view.AnimateViewProvider>(
        create: (context) => animate_view.AnimateViewProvider()..setLength(15),
        child: Consumer<animate_view.AnimateViewProvider>(
            builder: (context, provide, child) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                      child: DynamicList<String>(
                    animateViewProvider: provide,
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
    return ChangeNotifierProvider<animate_view.AnimateViewProvider>(
        create: (context) => animate_view.AnimateViewProvider()..setLength(animationListItems.length),
        child: Consumer<animate_view.AnimateViewProvider>(
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
                      animateViewProvider: provide,
                      headerBuilder: () => delta.SearchBox(
                        controller: _searchBoxController,
                      ),
                      footerBuilder: () => Container(
                        color: Colors.red,
                        child: const Text('footer'),
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
          ChangeNotifierProvider<animate_view.AnimateViewProvider>(
            create: (context) => animate_view.AnimateViewProvider()..setLength(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, animate_view.AnimateViewProvider>(
            builder: (context, selectedController, animateViewProvider, child) => MasterDetailView<String>(
                  animateViewProvider: animateViewProvider,
                  headerBuilder: () => delta.SearchBox(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => showTagView<SampleFilter>(
                        context,
                        onTagSelected: (value) => debugPrint('$value selected'),
                        tags: [
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
                  items: const ['a', 'b', 'c', 'd', 'e'],
                  selectedItems: const ['a'],
                  listBuilder: (String item, bool isSelected) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text('list:$item'),
                  ),
                  gridBuilder: (String item, bool isSelected) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                    child: Text('grid:$item'),
                  ),
                  contentBuilder: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Center(child: Text('content view')),
                  ),
                  onItemSelected: (items) {
                    selectedController.items = items;
                  },
                  onItemChecked: (items) {
                    selectedController.items = items;
                  },
                )));
  }

  Widget _showFilterView(BuildContext context) {
    return OutlinedButton(
      child: const Text('show folder view'),
      onPressed: () => showTagView<SampleFilter>(
        context,
        onTagSelected: (value) => debugPrint('$value selected'),
        tags: [
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

  Widget _tagView(BuildContext context) {
    return TagView<SampleFilter>(
      onTagSelected: (value) => debugPrint('$value selected'),
      header: const Text('I am header'),
      tags: [
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
          ChangeNotifierProvider<animate_view.AnimateViewProvider>(
            create: (context) => animate_view.AnimateViewProvider()..setLength(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, animate_view.AnimateViewProvider>(
          builder: (context, selectedController, animateViewProvider, child) => TagSplitView(
              tagView: TagView<SampleFilter>(
                onTagSelected: (value) => debugPrint('$value selected'),
                tags: [
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
                animateViewProvider: animateViewProvider,
                items: const ['a', 'b', 'c', 'd', 'e'],
                selectedItems: const ['a'],
                listBuilder: (String item, bool isSelected) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text('list:$item'),
                ),
                gridBuilder: (String item, bool isSelected) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 10),
                  child: Text('grid:$item'),
                ),
                contentBuilder: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Center(child: Text('content view')),
                ),
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
              foregroundColor: Colors.grey.shade900,
            ),
            label: const Text('Archive'),
            icon: const Icon(Icons.archive),
            onPressed: () {},
          ),
          SizedBox(height: 20, child: VerticalDivider(width: 5, color: Colors.grey.shade900)),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade900,
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
          ChangeNotifierProvider<animate_view.AnimateViewProvider>(
            create: (context) => animate_view.AnimateViewProvider()..setLength(5),
          ),
        ],
        child: Consumer<animate_view.AnimateViewProvider>(
            builder: (context, animateViewProvider, _) => MasterDetailView<String>(
                  animateViewProvider: animateViewProvider,
                  items: const [],
                  selectedItems: const [],
                  listBuilder: (String item, bool isSelected) => const SizedBox(),
                  gridBuilder: (String item, bool isSelected) => const SizedBox(),
                  contentBuilder: () => const Text('detail view'),
                )));
  }

  Widget _notesView(BuildContext context) {
    return ChangeNotifierProvider<animate_view.AnimateViewProvider>.value(
        value: _animateViewProvider,
        child: Consumer<animate_view.AnimateViewProvider>(
            builder: (context, animateViewProvider, _) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<NotesProvider<sample.Person>>.value(
                        value: _notesProvider,
                      ),
                      ChangeNotifierProvider<database.DatabaseProvider>(create: (_) {
                        return database.DatabaseProvider(
                          name: 'test',
                        )..load().then((database) {
                            _notesProvider.load(
                                context,
                                data.DatasetDatabase<sample.Person>(
                                  database,
                                  objectBuilder: () => sample.Person(),
                                ));
                          });
                      }),
                    ],
                    child: Consumer2<database.DatabaseProvider, NotesProvider<sample.Person>>(
                      builder: (context, databaseProvider, notesProvider, _) => NotesView<sample.Person>(
                        notesProvider: notesProvider,
                        contentBuilder: () => NoteForm<sample.Person>(formController: notesProvider.formController),
                        tagViewHeader: const Text('hello world'),
                        leftTools: [
                          responsive.ToolButton(
                            label: 'hello',
                            icon: Icons.favorite,
                            onPressed: () => debugPrint('hello'),
                          ),
                        ],
                        rightTools: [
                          responsive.ToolButton(
                            label: 'hello',
                            icon: Icons.ac_unit,
                            onPressed: () => debugPrint('hi'),
                          ),
                        ],
                      ),
                    ))));
  }
}

Widget _noteItem(BuildContext context, String id) {
  return MultiProvider(
      providers: [
        ChangeNotifierProvider<NotesProvider<sample.Person>>.value(
          value: _notesProvider,
        ),
        ChangeNotifierProvider<NoteFormController<sample.Person>>(
          create: (context) => createFormController(),
        ),
        ChangeNotifierProvider<database.DatabaseProvider>(
          create: (context) {
            return database.DatabaseProvider(
              name: 'test',
            )..load().then((database) async {
                NoteFormController.of<sample.Person>(context).load(context,
                    dataset: data.DatasetDatabase<sample.Person>(
                      database,
                      objectBuilder: () => sample.Person(),
                    ),
                    id: id);
              });
          },
        ),
      ],
      child: Consumer2<database.DatabaseProvider, NoteFormController<sample.Person>>(
          builder: (context, databaseProvider, formController, _) => Scaffold(
                appBar: AppBar(title: const Text('Detail'), actions: [
                  Consumer<NoteFormController<sample.Person>>(
                      builder: (context, formController, _) => NoteFormMenuButton<sample.Person>(
                            formController: formController,
                          )),
                ]),
                body: SafeArea(
                  child: Center(
                    child: NoteForm<sample.Person>(
                      formController: formController,
                      onWillPop: () async => formController.isAllowToExit(),
                    ),
                  ),
                ),
              )));
}
