import 'package:flutter/material.dart';
import 'package:libcli/module.dart';

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
  WaitPage() : super(i18nFilename: '');

  @override
  createProvider(BuildContext context) => WaitProvider();

  @override
  Widget createWidget(BuildContext context) => WaitWidget();
}
