// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/dataview/data.dart' as data;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/cache/cache.dart' as cache;
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

delta.AnimateViewProvider _animateViewProvider = delta.AnimateViewProvider()..setLength(5);

NotesProvider<sample.Person> _notesProvider = NotesProvider<sample.Person>(
  animateViewProvider: _animateViewProvider,
  caption: "Notes",
  formController: createFormController(),
  listBuilder: (context, sample.Person person, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Text('list:$person',
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          )),
    );
  },
  gridBuilder: (context, sample.Person person, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: Text('grid:$person', style: TextStyle(color: colorScheme.onSurface)),
    );
  },
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
    tools.Tag(
      label: 'Inbox',
      value: 'inbox',
      icon: Icons.inbox,
      count: 0,
    ),
    tools.Tag(
      label: 'VIPs',
      value: 'vips',
      icon: Icons.verified_user,
      count: 1,
      selected: true,
    ),
    tools.Tag(
      label: 'Sent',
      value: 'sent',
      icon: Icons.send,
      count: 20,
    ),
    tools.Tag(
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
  base.start(
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    appName: 'notes example',
    routesBuilder: () => {
      '/': (context, state, _) => dialog.cupertinoBottomSheet(const NotesExample()),
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
            items: [
              tools.ToolButton(
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
              child: _checkableList(context),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  testing.ExampleButton(label: 'simple list', builder: () => _simpleList(context)),
                  testing.ExampleButton(label: 'simple grid', builder: () => _simpleGrid(context)),
                  testing.ExampleButton(label: 'checkable grid', builder: () => _checkableGrid(context)),
                  testing.ExampleButton(label: 'checkable list', builder: () => _checkableList(context)),
                  testing.ExampleButton(label: 'DynamicList', builder: () => _dynamicList(context)),
                  testing.ExampleButton(label: 'DynamicGrid', builder: () => _dynamicGrid(context)),
                  testing.ExampleButton(label: 'GridListView', builder: () => _gridListView(context)),
                  testing.ExampleButton(label: 'DataView', builder: () => _dataView(context)),
                  testing.ExampleButton(label: 'NotesView', builder: () => _notesView(context)),
                  OutlinedButton(
                      child: const Text('scroll to top'),
                      onPressed: () => NotesProvider.of<sample.Person>(context).scrollToTop()),
                  testing.ExampleButton(label: 'filter split view', builder: () => _filterSplitView(context)),
                  testing.ExampleButton(label: 'selection header', builder: () => _selectionHeader(context)),
                  testing.ExampleButton(label: 'loading data', builder: () => _loadingMasterDetailView(context)),
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
              itemBuilder: (context, String item, bool isSelected) => Padding(
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
          itemBuilder: (context, String item, bool isSelected) => Padding(
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
        itemBuilder: (context, String item, bool isSelected) => Padding(
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
          itemBuilder: (context, String item, bool isSelected) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Text(item),
          ),
        ),
      ),
    ]);
  }

  Widget _dynamicList(BuildContext context) {
    return ChangeNotifierProvider<delta.AnimateViewProvider>(
        create: (context) => delta.AnimateViewProvider()..setLength(animationListItems.length),
        child: Consumer<delta.AnimateViewProvider>(
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
                      itemBuilder: (context, String item, bool isSelected) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(item),
                      ),
                    ),
                  ),
                ]))));
  }

  Widget _dynamicGrid(BuildContext context) {
    return ChangeNotifierProvider<delta.AnimateViewProvider>(
        create: (context) => delta.AnimateViewProvider()..setLength(animationListItems.length),
        child: Consumer<delta.AnimateViewProvider>(
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
                      itemBuilder: (context, String item, bool isSelected) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: Text(item),
                      ),
                    ),
                  ),
                ]))));
  }

  Widget _gridListView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.AnimateViewProvider>(
            create: (context) => delta.AnimateViewProvider()..setLength(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, delta.AnimateViewProvider>(
            builder: (context, selectedController, animateViewProvider, child) => GridListView<String>(
                  animateViewProvider: animateViewProvider,
                  headerBuilder: () => delta.SearchBox(
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => tools.showTagView<SampleFilter>(
                        context,
                        onTagSelected: (value) => debugPrint('$value selected'),
                        tags: [
                          tools.Tag<SampleFilter>(
                            label: 'Inbox',
                            value: SampleFilter.inbox,
                            icon: Icons.inbox,
                            count: 0,
                          ),
                          tools.Tag<SampleFilter>(
                            label: 'VIPs',
                            value: SampleFilter.vip,
                            icon: Icons.verified_user,
                            count: 1,
                            selected: true,
                          ),
                          tools.Tag<SampleFilter>(
                            label: 'Sent',
                            value: SampleFilter.sent,
                            icon: Icons.send,
                            count: 20,
                          ),
                          tools.Tag<SampleFilter>(
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
                  listBuilder: (context, String item, bool isSelected) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Text('list:$item'),
                  ),
                  gridBuilder: (context, String item, bool isSelected) => Container(
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

  Widget _filterSplitView(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<delta.AnimateViewProvider>(
            create: (context) => delta.AnimateViewProvider()..setLength(5),
          ),
          ChangeNotifierProvider<delta.RefreshButtonController>(
            create: (context) => delta.RefreshButtonController(),
          ),
          ChangeNotifierProvider<_SelectedController>(
            create: (context) => _SelectedController(),
          )
        ],
        child: Consumer2<_SelectedController, delta.AnimateViewProvider>(
          builder: (context, selectedController, animateViewProvider, child) => TagSplitView(
              tagView: tools.TagView<SampleFilter>(
                onTagSelected: (value) => debugPrint('$value selected'),
                tags: [
                  tools.Tag<SampleFilter>(
                    label: 'Inbox',
                    value: SampleFilter.inbox,
                    icon: Icons.inbox,
                    count: 0,
                  ),
                  tools.Tag<SampleFilter>(
                    label: 'VIPs',
                    value: SampleFilter.vip,
                    icon: Icons.verified_user,
                    count: 1,
                    selected: true,
                  ),
                  tools.Tag<SampleFilter>(
                    label: 'Sent',
                    value: SampleFilter.sent,
                    icon: Icons.send,
                    count: 20,
                  ),
                  tools.Tag<SampleFilter>(
                    label: 'All',
                    value: SampleFilter.all,
                    icon: Icons.all_inbox,
                    count: 120,
                    category: 'iCloud',
                  ),
                ],
              ),
              child: GridListView<String>(
                animateViewProvider: animateViewProvider,
                items: const ['a', 'b', 'c', 'd', 'e'],
                selectedItems: const ['a'],
                listBuilder: (context, String item, bool isSelected) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Text('list:$item'),
                ),
                gridBuilder: (context, String item, bool isSelected) => Container(
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
          ChangeNotifierProvider<delta.AnimateViewProvider>(
            create: (context) => delta.AnimateViewProvider()..setLength(5),
          ),
        ],
        child: Consumer<delta.AnimateViewProvider>(
            builder: (context, animateViewProvider, _) => GridListView<String>(
                  animateViewProvider: animateViewProvider,
                  items: const [],
                  selectedItems: const [],
                  listBuilder: (context, String item, bool isSelected) => const SizedBox(),
                  gridBuilder: (context, String item, bool isSelected) => const SizedBox(),
                  contentBuilder: () => const Text('detail view'),
                )));
  }

  Widget _dataView(BuildContext context) {
    return ChangeNotifierProvider<delta.AnimateViewProvider>.value(
        value: _animateViewProvider,
        child: Consumer<delta.AnimateViewProvider>(
            builder: (context, animateViewProvider, _) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<NotesProvider<sample.Person>>.value(
                        value: _notesProvider,
                      ),
                      ChangeNotifierProvider<cache.IndexedDbProvider>(create: (_) {
                        return cache.IndexedDbProvider(
                          dbName: 'notes_sample',
                        );
                      }),
                    ],
                    child: Consumer2<cache.IndexedDbProvider, NotesProvider<sample.Person>>(
                      builder: (context, indexedDbProvider, notesProvider, _) {
                        return base.LoadingScreen(
                          future: () async {
                            final isPreferMouse = context.isPreferMouse;
                            await indexedDbProvider.init();
                            _notesProvider.load(
                                isPreferMouse,
                                data.DatasetDb<sample.Person>(
                                  indexedDbProvider: indexedDbProvider,
                                  objectBuilder: () => sample.Person(),
                                ));
                          },
                          builder: () => DataView<sample.Person>(
                            notesProvider: notesProvider,
                            contentBuilder: () => NoteForm<sample.Person>(formController: notesProvider.formController),
                            leftTools: [
                              tools.ToolButton(
                                label: 'leftTool',
                                icon: Icons.favorite,
                                onPressed: () => debugPrint('hello'),
                              ),
                            ],
                            rightTools: [
                              tools.ToolButton(
                                label: 'rightTool',
                                icon: Icons.ac_unit,
                                onPressed: () => debugPrint('hi'),
                              ),
                            ],
                          ),
                        );
                      },
                    ))));
  }

  Widget _notesView(BuildContext context) {
    return ChangeNotifierProvider<delta.AnimateViewProvider>.value(
        value: _animateViewProvider,
        child: Consumer<delta.AnimateViewProvider>(
            builder: (context, animateViewProvider, _) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider<NotesProvider<sample.Person>>.value(
                        value: _notesProvider,
                      ),
                      ChangeNotifierProvider<cache.IndexedDbProvider>(create: (_) {
                        return cache.IndexedDbProvider(
                          dbName: 'notes_sample',
                        );
                      }),
                    ],
                    child: Consumer2<cache.IndexedDbProvider, NotesProvider<sample.Person>>(
                      builder: (context, indexedDbProvider, notesProvider, _) {
                        return base.LoadingScreen(
                          future: () async {
                            final isPreferMouse = context.isPreferMouse;
                            await indexedDbProvider.init();
                            _notesProvider.load(
                                isPreferMouse,
                                data.DatasetDb<sample.Person>(
                                  indexedDbProvider: indexedDbProvider,
                                  objectBuilder: () => sample.Person(),
                                ));
                          },
                          builder: () => NotesView<sample.Person>(
                            notesProvider: notesProvider,
                            contentBuilder: () => NoteForm<sample.Person>(formController: notesProvider.formController),
                            tagViewHeader: const Text('hello world'),
                            leftTools: [
                              tools.ToolButton(
                                label: 'leftTool',
                                icon: Icons.favorite,
                                onPressed: () => debugPrint('hello'),
                              ),
                            ],
                            rightTools: [
                              tools.ToolButton(
                                label: 'rightTool',
                                icon: Icons.ac_unit,
                                onPressed: () => debugPrint('hi'),
                              ),
                            ],
                          ),
                        );
                      },
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
        ChangeNotifierProvider<cache.IndexedDbProvider>(
          create: (context) {
            return cache.IndexedDbProvider(
              dbName: 'notes_sample',
            );
          },
        ),
      ],
      child: Consumer2<cache.IndexedDbProvider, NoteFormController<sample.Person>>(
          builder: (context, indexedDbProvider, formController, _) => Scaffold(
                appBar: AppBar(title: const Text('Detail'), actions: [
                  Consumer<NoteFormController<sample.Person>>(
                      builder: (context, formController, _) => NoteFormMenuButton<sample.Person>(
                            formController: formController,
                          )),
                ]),
                body: base.LoadingScreen(
                  future: () async {
                    final noteFormController = NoteFormController.of<sample.Person>(context);
                    await indexedDbProvider.init();
                    noteFormController.load(
                        dataset: data.DatasetDb<sample.Person>(
                          indexedDbProvider: indexedDbProvider,
                          objectBuilder: () => sample.Person(),
                        ),
                        id: id);
                  },
                  builder: () => SafeArea(
                    child: Center(
                      child: NoteForm<sample.Person>(
                        formController: formController,
                        onWillPop: () async => formController.isAllowToExit(),
                      ),
                    ),
                  ),
                ),
              )));
}
