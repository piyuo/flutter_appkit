import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/dialog/dialog.dart' as dialog;
import '../responsive.dart';

main() {
  app.start(
    title: 'responsive example',
    routes: {
      '/': (context, state, data) => dialog.cupertinoBottomSheet(const ResponsiveExample()),
    },
  );
}

class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: ResponsiveDrawer(
        itemCount: 1,
        itemBuilder: (context, index) => ListTile(
          title: Text('$index'),
        ),
      ),
      endDrawer: ResponsiveDrawer(
        isEndDrawer: true,
        itemCount: 1,
        itemBuilder: (context, index) => ListTile(
          title: Text('$index'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _showResponsiveDialog(context),
            ),
            Wrap(
              children: [
                testing.ExampleButton(label: 'show responsive dialog', builder: () => _showResponsiveDialog(context)),
                testing.ExampleButton(label: 'fold panel', builder: () => _foldPanel(context)),
                testing.ExampleButton(label: 'toolbar', builder: () => _toolbar(context)),
                testing.ExampleButton(label: 'tool sheet', builder: () => _showToolSheet(context)),
                testing.ExampleButton(label: 'padding to center', builder: () => _paddingToCenter(context)),
                testing.ExampleButton(
                    label: 'layout dynamic bottom side', builder: () => _layoutDynamicBottomSide(context)),
                testing.ExampleButton(label: 'wrapped-list-view', builder: () => _wrappedListView(context)),
                testing.ExampleButton(label: 'responsive', builder: () => _responsive(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _foldPanel(BuildContext context) {
    return FoldPanel(
        builder: (isColumn) => [
              Expanded(
                  child: Container(
                color: Colors.red,
                child: Text('$isColumn'),
              )),
              Expanded(
                  child: Container(
                color: Colors.blue,
                child: Text('$isColumn'),
              )),
            ]);
  }

  Widget _showResponsiveDialog(BuildContext context) {
    return OutlinedButton(
      child: const Text('show responsive dialog'),
      onPressed: () => showResponsiveDialog<void>(
        context,
        itemCount: 11,
        itemBuilder: (context, index) => const [
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          Text('hello world'),
          SizedBox(height: 20),
        ][index],
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
      phoneScreen: () => Container(color: Colors.red, child: const Text('phone')),
      notPhoneScreen: () => Container(color: Colors.blue, child: const Text('not phone')),
      bigScreen: () => Container(color: Colors.green, child: const Text('big screen')),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Column(children: [
      Toolbar(
//        color: Colors.blue.shade300,
        //      activeColor: Colors.blue,
        items: [
          ToolButton(
            label: 'New File',
            icon: Icons.new_label,
            onPressed: () => debugPrint('new_file pressed'),
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
            text: 'page 2 of more',
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
            text: 'Disabled',
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
          ToolButton(
            label: 'Back',
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

  Widget _showToolSheet(BuildContext context) {
    return OutlinedButton(
      child: const Text('show tool sheet'),
      onPressed: () async {
        await showToolSheet(
          context,
          items: [
            ToolButton(
              label: 'New File',
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
    );
  }
}
