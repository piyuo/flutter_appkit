import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/pattern.dart';
import 'package:libcli/i18n.dart';

///ProviderWidget is widget that build by provider model
///
abstract class ProviderWidget<T extends AsyncProvider> extends StatelessWidget {
  /// i18nFilename is language file that widget need
  ///
  final String i18nFilename;

  /// package set if i18nfile is in other package
  ///
  final String package;

  /// ProviderWidget
  ///
  ProviderWidget({this.i18nFilename, this.package});

  /// createProvider create provider that widget need
  ///
  T createProvider(BuildContext context);

  /// createWidget to create widget for content
  ///
  Widget createWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<I18nProvider>(
          create: (context) => I18nProvider(i18nFilename, package: package),
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
                child: createWidget(context),
              )),
    );
  }
}
