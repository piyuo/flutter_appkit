import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/dialog/dialog.dart' as dialog;

import '../tools.dart';

enum SampleFilter { inbox, vip, sent, all }

main() {
  base.start(
    appName: 'tools example',
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    routesBuilder: () => {
      '/': (context, _, __) => dialog.cupertinoBottomSheet(const ToolsExample()),
    },
  );
}

class ToolsExample extends StatefulWidget {
  const ToolsExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ToolsExampleState();
}

class _ToolsExampleState extends State<ToolsExample> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ResponsiveListViewProvider<int>>(
              create: (context) => ResponsiveListViewProvider<int>(value: 0)),
        ],
        child: Consumer<ResponsiveListViewProvider<int>>(
            builder: (context, responsiveListViewProvider, child) => Scaffold(
                  appBar: AppBar(
                    title: const Text('tools example'),
                    leading: delta.isPhoneScreen(width) && !responsiveListViewProvider.isSideView
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () => responsiveListViewProvider.useSideView(),
                          )
                        : null,
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: _stickyHeader(context),
                      ),
                      SizedBox(
                        height: 300,
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              testing.ExampleButton(
                                  label: 'NavigationView',
                                  useScaffold: false,
                                  builder: () => _responsiveListView(context)),
                              testing.ExampleButton(label: 'tag view', builder: () => _tagView(context)),
                              testing.ExampleButton(label: 'show tag view', builder: () => _showTagView(context)),
                              testing.ExampleButton(label: 'StickyHeader', builder: () => _stickyHeader(context)),
                              testing.ExampleButton(label: 'PullRefresh', builder: () => _pullFresh(context)),
                              testing.ExampleButton(label: 'LoadMore', builder: () => _loadMore(context)),
                              testing.ExampleButton(label: 'Refresh More', builder: () => _refreshMore(context)),
                              testing.ExampleButton(label: 'toolbar', builder: () => _toolbar(context)),
                              testing.ExampleButton(label: 'menu button', builder: () => _menuButton(context)),
                              testing.ExampleButton(label: 'button panel', builder: () => _buttonPanel(context)),
                              testing.ExampleButton(label: 'PagingToolbar', builder: () => _selectBar(context)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )));
  }

  Widget _responsiveListView(BuildContext context) {
    return ResponsiveListView<int>(
      sideBuilder: (navigationViewProvider) => Container(
          color: Colors.blue,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => navigationViewProvider.show(context, 1),
                child: const Text('show 1'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => navigationViewProvider.show(context, 2),
                child: const Text('show 2'),
              ),
            ],
          )),
      builder: (int value) => Container(
        color: Colors.green,
        child: Column(children: [Text('$value')]),
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

  Widget _showTagView(BuildContext context) {
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

  int itemIndex = 6;
  final List<String> items = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];

  Widget _refreshMore(BuildContext context) {
    return ChangeNotifierProvider<RefreshMoreProvider>(
        create: (context) => RefreshMoreProvider(),
        child: Consumer<RefreshMoreProvider>(
            builder: (context, refreshMoreProvider, _) => RefreshMore(
                refreshMoreProvider: refreshMoreProvider,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 3));
                  //throw Exception('error');
                  itemIndex = 6;
                  debugPrint('refresh done');
                },
                onMore: () async {
                  await Future.delayed(const Duration(seconds: 3));
                  //return true;
                  //throw Exception('error');
                  itemIndex += 2;
                  if (itemIndex >= items.length) {
                    itemIndex = items.length;
                    return true; // no more data
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final String item = items[index];
                          return ListTile(
                            leading: CircleAvatar(child: Text(item)),
                            title: Text('This item represents $item.'),
                            isThreeLine: true,
                            subtitle: const Text('Even more additional list item information appears on line three'),
                          );
                        },
                        childCount: itemIndex,
                      ),
                    ),
                  ],
                ))));
  }

  Widget _loadMore(BuildContext context) {
    return ChangeNotifierProvider<RefreshMoreProvider>(
        create: (context) => RefreshMoreProvider(),
        child: Consumer<RefreshMoreProvider>(
            builder: (context, refreshMoreProvider, _) => LoadMore(
                  refreshMoreProvider: refreshMoreProvider,
                  onMore: () async {
                    await Future.delayed(const Duration(seconds: 2));
                    //return true;
                    //throw Exception('error');
                    itemIndex += 2;
                    if (itemIndex >= items.length) {
                      itemIndex = items.length;
                      return true; // no more data
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final String item = items[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text(item)),
                              title: Text('This item represents $item.'),
                              isThreeLine: true,
                              subtitle: const Text('Even more additional list item information appears on line three'),
                            );
                          },
                          childCount: itemIndex,
                        ),
                      ),
                    ],
                  ),
                )));
  }

  Widget _pullFresh(BuildContext context) {
    return ChangeNotifierProvider<RefreshMoreProvider>(
        create: (context) => RefreshMoreProvider(),
        child: Consumer<RefreshMoreProvider>(
            builder: (context, refreshMoreProvider, _) => PullRefresh(
                  refreshMoreProvider: refreshMoreProvider,
                  onRefresh: () async {
                    debugPrint('refresh');
                    await Future.delayed(const Duration(seconds: 2));
                    debugPrint('refresh done');
                  },
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: ElevatedButton(
                          onPressed: () {
                            refreshMoreProvider.showRefreshAnimation(!refreshMoreProvider.isRefreshAnimation);
                          },
                          child: const Text('Refresh'),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final String item = items[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text(item)),
                              title: Text('This item represents $item.'),
                              isThreeLine: true,
                              subtitle: const Text('Even more additional list item information appears on line three'),
                            );
                          },
                          childCount: itemIndex,
                        ),
                      ),
                    ],
                  ),
                )));
  }

  List groupItems = [
    {'name': 'John', 'group': 'Team A'},
    {'name': 'Will', 'group': 'Team B'},
    {'name': 'Beth', 'group': 'Team A'},
    {'name': 'Miranda', 'group': 'Team B'},
    {'name': 'Mike', 'group': 'Team C'},
    {'name': 'Danny', 'group': 'Team C'},
  ];

  Widget _stickyHeader(BuildContext context) {
    return CustomScrollView(
      slivers: [
        StickyHeader(
          headerBuilder: () => Container(
            height: 60.0,
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: const Text('Header #0', style: TextStyle(color: Colors.white)),
          ),
          builder: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(
                leading: const CircleAvatar(child: Text('0')),
                title: Text('List tile #$i'),
              ),
              childCount: 4,
            ),
          ),
        ),
        StickyHeader(
          headerBuilder: () => Container(
            height: 60.0,
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: const Text('Header #1', style: TextStyle(color: Colors.white)),
          ),
          builder: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(
                leading: const CircleAvatar(child: Text('0')),
                title: Text('List tile #$i'),
              ),
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectBar(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => SelectBarProvider(),
        child: Consumer<SelectBarProvider>(
            builder: (context, pagingToolbarProvider, _) => SelectBar(
                  selectBarProvider: pagingToolbarProvider,
                  onSelectAllChanged: (selectAll) {
                    selectAll
                        ? pagingToolbarProvider.setSelectedInfo(12, 12)
                        : pagingToolbarProvider.setSelectedInfo(0, 12);
                    debugPrint('select all: $selectAll');
                  },
                  onRefresh: () async {},
                  onNew: () {},
                  actionsAfterSelect: [
                    ToolButton(
                      label: 'Archive',
                      icon: Icons.archive,
                      onPressed: () {},
                    ),
                    ToolButton(
                      label: 'Delete',
                      icon: Icons.delete,
                      onPressed: () {},
                    ),
                  ],
                  child: Container(color: Colors.red),
                )));
  }

  Widget _buttonPanel(BuildContext context) {
    return ButtonPanel<String>(
      onPressed: (item) => debugPrint('$item pressed'),
      checkedValues: const ['1'],
      children: const {
        '0': Row(children: [
          Expanded(
            child: Text('button', style: TextStyle(fontSize: 18)),
          ),
          Icon(Icons.add),
        ]),
        '1': Row(children: [
          Expanded(
            child: Text('button 1', style: TextStyle(fontSize: 18)),
          ),
          Icon(Icons.dark_mode),
        ]),
        '2': Row(children: [
          Expanded(
            child: Text('button 2', style: TextStyle(fontSize: 18)),
          ),
          Icon(Icons.accessibility),
        ]),
      },
    );
  }

  Widget _menuButton(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 40),
      const Text('General'),
      SizedBox(
        width: 140,
        child: MenuButton<String>(
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Settings'),
            onPressed: (value) {
              debugPrint('$value pressed');
            },
            selectedValue: '2',
            selection: const {
              '1': 'hello',
              '2': 'world',
            }),
      ),
      const Text('Disabled'),
      const MenuButton<String>(
        icon: Icon(Icons.settings),
        onPressed: null,
        selectedValue: '2',
        selection: {
          '1': 'hello',
          '2': 'world',
        },
      ),
      const Text('Empty'),
      const MenuButton<String>(
        onPressed: null,
        selectedValue: '2',
        selection: {},
      ),
    ]);
  }

  Widget _toolbar(BuildContext context) {
    return Column(children: [
      Toolbar(
        items: [
          ToolButton(
            label: 'Show tool sheet',
            icon: Icons.new_label,
            onPressed: () async {
              await showToolSheet(
                context,
                items: [
                  ToolButton(
                    label: 'New File',
                    //text: 'Hello File',
                    icon: Icons.new_label,
                    onPressed: () => debugPrint('new_file pressed'),
                  ),
                  ToolButton(
                    label: 'Disabled',
                    icon: Icons.cabin,
                  ),
                  ToolButton(
                    label: 'abc',
                    icon: Icons.abc_outlined,
                    onPressed: () => debugPrint('abc pressed'),
                  ),
                  ToolSelection(
                    label: 'Rows per page',
                    icon: Icons.table_rows,
                    selection: {
                      '10': '10 rows2',
                      '20': '20 rows2',
                      '50': '50 rows2',
                      '100': '100 rows2',
                      '200': '200 rows2',
                    },
                    onPressed: (value) => debugPrint('$value pressed'),
                  ),
                  ToolText(label: '1 of 10'),
                  ToolButton(
                    label: 'hi',
                    icon: Icons.hail,
                    onPressed: () => debugPrint('hi pressed'),
                  ),
                  ToolButton(
                    label: 'hello',
                    icon: Icons.handshake,
                    onPressed: () => debugPrint('hello pressed'),
                  ),
                ],
              );
            },
            space: 10,
          ),
          ToolButton(
            label: 'List View',
            icon: Icons.list,
            onPressed: () => debugPrint('list_view pressed'),
            active: true,
          ),
          ToolButton(
            label: 'Grid View',
            icon: Icons.grid_view,
            onPressed: () => debugPrint('grid_view pressed'),
            active: false,
            space: 10,
          ),
          ToolSelection(
            width: 150,
            label: 'rows per page',
            selection: {
              '10': '10 rows',
              '20': '20 rows',
              '50': '50 rows',
            },
            onPressed: (value) => debugPrint('$value pressed'),
          ),
          ToolSelection(
            width: 120,
            label: 'disabled',
            selection: {
              '10': '10 rows',
            },
          ),
          ToolButton(
            label: 'disabled',
            icon: Icons.delete,
          ),
          ToolSpacer(),
          ToolText(label: '1 of 10'),
          ToolButton(
            label: 'Back1',
            icon: Icons.chevron_left,
            onPressed: () => debugPrint('back pressed'),
          ),
          ToolButton(
            label: 'Next',
            icon: Icons.chevron_right,
            onPressed: () => debugPrint('next pressed'),
          ),
          ToolButton(
            label: 'Disabled',
            icon: Icons.cabin,
            onPressed: () => debugPrint('disabled pressed'),
            space: 10,
          ),
        ],
      ),
    ]);
  }
}
