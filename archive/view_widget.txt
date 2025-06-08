import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;

delta.AsyncProvider? viewWidgetProviderInstanceForTest;

///ProviderWidget is widget that build by provider model
///
abstract class ViewWidget<T extends delta.AsyncProvider> extends StatelessWidget {
  /// i18nFile is language file that widget need
  ///
  final String? i18nFile;

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
  const ViewWidget({
    Key? key,
    this.i18nFile,
    this.i18nPackage,
    this.i18nFile2,
    this.i18nPackage2,
  }) : super(key: key);

  /// createProvider create provider that widget need, it will assign redux to redux provider
  ///
  T createProvider(BuildContext context);

  /// createWidget to create widget for content
  ///
  Widget createWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    List<SingleChildWidget> providers = [
      ChangeNotifierProvider<T>(
        create: (context) {
          var p = createProvider(context);
          if (!kReleaseMode) {
            viewWidgetProviderInstanceForTest = p;
          }
          return p;
        },
      )
    ];
    if (i18nFile == null) {
      return MultiProvider(
        providers: providers,
        child: Consumer<T>(
            builder: (context, provider, child) => delta.Await(
                  [provider],
                  child: createWidget(context),
                )),
      );
    }

    providers.add(
      ChangeNotifierProvider<i18n.I18nProvider>(
        create: (context) => i18n.I18nProvider(
          fileName: i18nFile!,
          package: i18nPackage,
          fileName2: i18nFile2,
          package2: i18nPackage2,
        ),
      ),
    );

    return MultiProvider(
      providers: providers,
      child: Consumer2<i18n.I18nProvider, T>(
          builder: (context, i18nProvider, provider, child) => delta.Await(
                [i18nProvider, provider],
                child: createWidget(context),
              )),
    );
  }
}
