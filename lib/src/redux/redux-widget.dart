import 'package:libcli/redux.dart';
import 'package:libcli/src/redux/provider-widget.dart';

///ProviderWidget is widget that build by provider model
///
abstract class ReduxWidget<T extends ReduxProvider> extends ProviderWidget<T> {
  /// redux
  ///
  final Redux redux;

  /// ReduxWidget create instance wih redux and default i18nFilename
  ///
  ReduxWidget(this.redux, String i18nFilename, {String package}) : super(i18nFilename, package: package) {
    assert(redux != null, 'redux must no be null');
  }

  @override
  void onProviderCreated(T provider) {
    provider.redux = redux;
  }
}
