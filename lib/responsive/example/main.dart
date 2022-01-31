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

  Widget _responsive(BuildContext context) {
    return Responsive(
      phone: () => Container(child: const Text('phone'), color: Colors.red),
      notPhone: () => Container(child: const Text('desktop'), color: Colors.blue),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Column(children: [
      Toolbar<String>(
        onPressed: (index) => debugPrint('just press $index'),
        items: [
          ToolButton(
            label: 'New File',
            icon: Icons.new_label,
            value: 'new_file',
          ),
          ToolButton(
            label: 'List View',
            icon: Icons.list,
            value: 'list_view',
            active: true,
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
            active: true,
          ),
          ToolSpace(),
        ],
      ),
    ]);
  }
}
