import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/src/module/async-provider.dart';
import 'package:libcli/src/module/await.dart';

AsyncProvider? viewWidgetProviderInstanceForTest;

///ProviderWidget is widget that build by provider model
///
abstract class ViewWidget<T extends AsyncProvider> extends StatelessWidget {
  /// i18nFile is language file that widget need
  ///
  final String i18nFile;

  /// i18nPackage need set if i18n file is in other package
  ///
  final String? i18nPackage;

  /// i18nFile2 is language file that widget need
  ///
  final String? i18nFile2;

  /// i18nPackage2 need set if i18n file is in other package
  ///
  final String? i18nPackage2;

  /// ProviderWidget
  ///
  ViewWidget({
    required this.i18nFile,
    this.i18nPackage,
    this.i18nFile2,
    this.i18nPackage2,
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
          create: (context) => i18n.I18nProvider(
            fileName: i18nFile,
            package: i18nPackage,
            fileName2: i18nFile2,
            package2: i18nPackage2,
          ),
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
          builder: (context, i18nProvider, provider, child) => Await(
                list: [i18nProvider, provider],
                child: createWidget(context),
              )),
    );
  }
}
