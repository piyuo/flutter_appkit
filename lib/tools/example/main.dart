import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/dialog/dialog.dart' as dialog;

import '../tools.dart';

main() {
  base.start(
    appName: 'tools example',
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    routesBuilder: () => {
      '/': (context, _, __) => dialog.cupertinoBottomSheet(const Example()),
    },
  );
}

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _toolbar(context),
            ),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    testing.ExampleButton(label: 'toolbar', builder: () => _toolbar(context)),
                    testing.ExampleButton(label: 'menu button', builder: () => _menuButton(context)),
                    testing.ExampleButton(label: 'button panel', builder: () => _buttonPanel(context)),
                    testing.ExampleButton(label: 'PagingToolbar', builder: () => _pagingToolbar(context)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagingToolbar(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => PagingToolbarProvider(),
        child: Consumer<PagingToolbarProvider>(
            builder: (context, pagingToolbarProvider, _) => PagingToolbar(
                  pagingToolbarProvider: pagingToolbarProvider,
                  onSelectAllChanged: (selectAll) {
                    selectAll
                        ? pagingToolbarProvider.setSelectedInfo(12, 12)
                        : pagingToolbarProvider.setSelectedInfo(0, 12);
                    debugPrint('select all: $selectAll');
                  },
                  onSetRowsPerPage: (rowsPerPage) {
                    debugPrint('rows per page: $rowsPerPage');
                  },
                  onPreviousPage: () {
                    debugPrint('previous page');
                  },
                  onNextPage: () {
                    debugPrint('next page');
                  },
                  onRefresh: () async {},
                  actionsAfterSelect: [
                    TextButton.icon(
                      label: const Text('Archive'),
                      icon: const Icon(Icons.archive),
                      onPressed: () {},
                    ),
                    SizedBox(height: 20, child: VerticalDivider(width: 5, color: Colors.grey.shade900)),
                    TextButton.icon(
                      label: const Text('Delete'),
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ],
                  child: Container(color: Colors.green),
                )));
  }

  Widget _buttonPanel(BuildContext context) {
    return ButtonPanel<String>(
      onPressed: (item) => debugPrint('$item pressed'),
      checkedValues: const ['1'],
      children: {
        '0': Row(children: const [
          Expanded(
            child: Text('button', style: TextStyle(fontSize: 18)),
          ),
          Icon(Icons.add),
        ]),
        '1': Row(children: const [
          Expanded(
            child: Text('button 1', style: TextStyle(fontSize: 18)),
          ),
          Icon(Icons.dark_mode),
        ]),
        '2': Row(children: const [
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
