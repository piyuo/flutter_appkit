import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import '../responsive.dart';

main() {
  app.start(
    appName: 'responsive',
    routes: {
      '/': (context, state, data) => const ResponsiveExample(),
    },
  );
}

class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _toolbar(context),
            ),
            Wrap(
              children: [
                testing.ExampleButton(label: 'toolbar', builder: () => _toolbar(context)),
                testing.ExampleButton(label: 'tool menu', builder: () => _showToolMenu(context)),
                testing.ExampleButton(label: 'padding to center', builder: () => _paddingToCenter(context)),
                testing.ExampleButton(
                    label: 'layout dynamic bottom side', builder: () => _layoutDynamicBottomSide(context)),
                testing.ExampleButton(label: 'wrapped-list-view', builder: () => _wrappedListView(context)),
                testing.ExampleButton(label: 'responsive design', builder: () => _responsive(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paddingToCenter(BuildContext context) {
    return Container(
      margin: paddingToCenter(context, 1024),
      color: Colors.red,
      height: 200,
    );
  }

  Widget _wrappedListView(BuildContext context) {
    return WrappedListView(
      children: [
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.red,
          ),
          children: [
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.orange,
            ),
          ],
        ),
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.yellow,
          ),
          children: [
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _layoutDynamicBottomSide(BuildContext context) {
    return DynamicBottomSide(
      leftBuilder: () => Container(
        color: Colors.red,
        width: 200,
      ),
      centerBuilder: () => Container(color: Colors.yellow),
      sideBuilder: () => Container(
        color: Colors.blue,
        width: 300,
      ),
      bottomBuilder: () => Container(
        color: Colors.green,
        height: 100,
      ),
    );
  }

  Widget _responsive(BuildContext context) {
    return Responsive(
      phone: () => Container(child: const Text('phone'), color: Colors.red),
      notPhone: () => Container(child: const Text('desktop'), color: Colors.blue),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Column(children: [
      Toolbar<String>(
        color: Colors.blue.shade300,
        activeColor: Colors.blue,
        onPressed: (index) => debugPrint('just press $index'),
        items: [
          ToolButton(
            label: 'New File',
            icon: Icons.new_label,
            value: 'new_file',
            space: 10,
          ),
          ToolButton(
            label: 'List View',
            icon: Icons.list,
            value: 'list_view',
            active: true,
          ),
          ToolButton(
            label: 'Grid View',
            icon: Icons.grid_view,
            value: 'grid_view',
            active: false,
            space: 10,
          ),
          ToolSelection<String>(
            width: 120,
            text: 'page 2 of more',
            label: 'rows per page',
            selection: {
              '10': '10 rows',
              '20': '20 rows',
              '50': '50 rows',
            },
          ),
          ToolSelection<String>(
            width: 120,
            text: 'Disabled',
            label: '',
            selection: {
              '10': '10 rows',
            },
          ),
          ToolButton(
            width: 42,
            text: '3/4',
            label: 'delete',
            value: 'page info',
          ),
          ToolButton(
            width: 62,
            label: 'Hello',
            value: 'delete2',
          ),
          ToolButton(
            label: 'delete3',
            icon: Icons.delete,
            value: 'delete3',
          ),
          ToolSelection(
            value: '20',
            label: 'Rows per page2',
            icon: Icons.table_rows,
            selection: {
              '10': '10 rows2',
              '20': '20 rows2',
              '50': '50 rows2',
            },
          ),
          ToolButton(
            label: 'delete4',
            icon: Icons.delete,
            value: 'delete4',
          ),
          ToolSpacer(),
          ToolButton(
            label: 'Back',
            icon: Icons.chevron_left,
            value: 'back',
          ),
          ToolButton(
            label: 'Next',
            icon: Icons.chevron_right,
            value: 'next',
          ),
          ToolButton(
            label: 'Disabled',
            icon: Icons.cabin,
            value: null,
            space: 10,
          ),
        ],
      ),
      Row(children: [
        Expanded(
            child: Toolbar<String>(
                color: Colors.blue.shade300,
                activeColor: Colors.blue,
                onPressed: (index) => debugPrint('just press $index'),
                items: [
              ToolButton(
                label: 'New File',
                icon: Icons.new_label,
                value: 'new_file',
                space: 10,
              ),
              ToolButton(
                label: 'List View',
                icon: Icons.list,
                value: 'list_view',
                active: true,
              ),
              ToolButton(
                label: 'Grid View',
                icon: Icons.grid_view,
                value: 'grid_view',
                active: false,
                space: 10,
              ),
              ToolSelection<String>(
                width: 120,
                text: 'page 2 of more',
                label: 'rows per page',
                selection: {
                  '10': '10 rows',
                  '20': '20 rows',
                  '50': '50 rows',
                },
              ),
              ToolSpacer(),
              ToolButton(
                label: 'Back',
                icon: Icons.chevron_left,
                value: 'back',
              ),
              ToolButton(
                label: 'Next',
                icon: Icons.chevron_right,
                value: 'next',
              ),
              ToolButton(
                label: 'Disabled',
                icon: Icons.cabin,
                value: null,
                space: 10,
              ),
            ])),
        const SizedBox(width: 450),
      ])
    ]);
  }

  Widget _showToolMenu(BuildContext context) {
    return OutlinedButton(
      child: const Text('tool menu'),
      onPressed: () async {
        final value = await showToolMenu<String>(
          context,
          items: [
            ToolButton(
              label: 'New File',
              icon: Icons.new_label,
              value: 'new_file',
            ),
            ToolButton(
              label: 'Disabled',
              icon: Icons.cabin,
              value: null,
            ),
            ToolButton(
              label: 'abc',
              icon: Icons.abc_outlined,
              value: 'abc',
            ),
            ToolSelection(
              value: '20',
              label: 'Rows per page',
              icon: Icons.table_rows,
              selection: {
                '10': '10 rows2',
                '20': '20 rows2',
                '50': '50 rows2',
              },
            ),
            ToolSpacer(),
            ToolButton(
              label: 'hi',
              icon: Icons.hail,
              value: 'hi',
            ),
          ],
        );
        debugPrint('just press $value');
      },
    );
  }
}
