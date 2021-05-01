import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/module/async-provider.dart';
import 'package:libcli/src/module/await.dart';
import 'package:libcli/src/i18n.dart' as i18n;

AsyncProvider? viewWidgetProviderInstanceForTest;

///ProviderWidget is widget that build by provider model
///
abstract class ViewWidget<T extends AsyncProvider> extends StatelessWidget {
  /// i18nFilename is language file that widget need
  ///
  final String i18nFilename;

  /// package set if i18n file is in other package
  ///
  final String? package;

  /// ProviderWidget
  ///
  ViewWidget({
    required this.i18nFilename,
    this.package,
  });

  /// createProvider create provider that widget need, it will assign redux to redux provider
  ///
  T createProvider(BuildContext context);

  /// createWidget to create widget for content
  ///
  Widget createWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<i18n.I18nProvider>(
          create: (context) => i18n.I18nProvider(fileName: i18nFilename, package: package),
        ),
        ChangeNotifierProvider<T>(
          create: (context) {
            var p = createProvider(context);
            if (!kReleaseMode) {
              viewWidgetProviderInstanceForTest = p;
            }
            return p;
          },
        )
      ],
      child: Consumer2<i18n.I18nProvider, T>(
          builder: (context, i18n, provider, child) => Await(
                list: [i18n, provider],
                child: createWidget(context),
              )),
    );
  }
}
