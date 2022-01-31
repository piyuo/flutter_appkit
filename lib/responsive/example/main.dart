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
              child: _wrappedListView(context),
            ),
            Wrap(
              children: [
                testing.example(
                  context,
                  text: 'padding to center',
                  child: _paddingToCenter(context),
                ),
                testing.example(
                  context,
                  text: 'layout dynamic bottom side',
                  child: _layoutDynamicBottomSide(context),
                ),
                testing.example(
                  context,
                  text: 'wrapped-list-view',
                  child: _wrappedListView(context),
                ),
                testing.example(
                  context,
                  text: 'responsive design',
                  child: _responsive(context),
                ),
                testing.example(
                  context,
                  text: 'toolbar',
                  child: _toolbar(context),
                ),
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
            marginRight: 10,
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
            marginRight: 10,
          ),
          ToolSelection(
            label: 'Rows per page',
            icon: Icons.table_rows,
            selection: {
              '10': '10 rows',
              '20': '20 rows',
              '50': '50 rows',
            },
          ),
          ToolButton(
            label: 'delete',
            icon: Icons.delete,
            value: 'delete',
          ),
          ToolButton(
            label: 'delete2',
            icon: Icons.delete,
            value: 'delete2',
          ),
          ToolButton(
            label: 'delete3',
            icon: Icons.delete,
            value: 'delete3',
          ),
          ToolSelection(
            checkedValue: '20',
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
          ToolSpace(),
          ToolButton(
            label: 'delete5',
            icon: Icons.delete,
            value: 'delete5',
          ),
        ],
      ),
    ]);
  }
}
