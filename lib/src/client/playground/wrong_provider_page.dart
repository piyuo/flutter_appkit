import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/pattern.dart';

class WrongProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await exceptionHappen();
  }

  exceptionHappen() async {
    throw 'load error';
  }
}

class WrongWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Container());
  }
}

class WrongProviderPage extends ProviderWidget<WrongProvider> {
  WrongProviderPage() : super(i18nFilename: 'WrongProviderPage');

  @override
  createProvider(BuildContext context) => WrongProvider();

  @override
  Widget createWidget(BuildContext context) => WrongWidget();
}
