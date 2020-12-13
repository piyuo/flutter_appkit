import 'package:flutter/material.dart';
import 'package:libcli/module.dart';

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
  WrongPage() : super(i18nFilename: '');

  @override
  createProvider(BuildContext context) => WrongProvider();

  @override
  Widget createWidget(BuildContext context) => WrongWidget();
}
