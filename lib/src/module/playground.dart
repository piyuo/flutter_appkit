import 'package:flutter/material.dart';
import 'package:libcli/src/module/async-provider.dart';
import 'package:libcli/src/module/view-widget.dart';

class ModulePlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(
          children: [
            TextButton(
              child: Text('provider with problem'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WrongPage();
                }));
              },
            ),
            TextButton(
              child: Text('provider need wait 30\'s'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WaitPage();
                }));
              },
            ),
          ],
        ),
      ],
    ));
  }
}

class WaitProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(seconds: 30));
  }
}

class WaitWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

class WaitPage extends ViewWidget<WaitProvider> {
  WaitPage() : super(i18nFile: '');

  @override
  createProvider(BuildContext context) => WaitProvider();

  @override
  Widget createWidget(BuildContext context) => WaitWidget();
}

class WrongProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    throw Exception('load error');
  }
}

class WrongWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}

class WrongPage extends ViewWidget<WrongProvider> {
  WrongPage() : super(i18nFile: '');

  @override
  createProvider(BuildContext context) => WrongProvider();

  @override
  Widget createWidget(BuildContext context) => WrongWidget();
}
