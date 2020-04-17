import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';

class ProviderWidget<T extends AsyncProvider> extends StatelessWidget {
  final String i18nFilename;

  ProviderWidget(this.i18nFilename);

  @protected
  T createProvider(BuildContext context) {
    return null;
  }

  @protected
  Widget onBuild(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider(i18nFilename),
        ),
        ChangeNotifierProvider<T>(
          create: (context) {
            var p = createProvider(context);
            assert(p != null,
                '$runtimeType must override createProvider and do no return null');
            return p;
          },
        )
      ],
      child: Consumer2<I18nProvider, T>(
          builder: (context, i18n, provider, child) => Await(
                list: [i18n, provider],
                child: onBuild(context),
              )),
    );
  }
}
