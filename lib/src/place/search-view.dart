import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/locate.dart' as locate;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/delta.dart' as delta;
import 'search-confirm.dart';
import 'show-search.dart';

class SearchViewProvider with ChangeNotifier {
  SearchViewProvider({
    required this.myLocationButtonProvider,
    required this.confirmButtonProvider,
    required this.onClickMyLocation,
    required this.onClickConfirm,
  }) {}

  /// myLocationButtonProvider control my location button visibility
  final MyLocationButtonProvider myLocationButtonProvider;

  /// confirmButtonProvider control confirm button visibility
  final ConfirmButtonProvider confirmButtonProvider;

  /// onClickMyLocation trigger when user click my location button
  final void Function(BuildContext context) onClickMyLocation;

  /// onClickConfirm trigger when user click confirm
  final void Function() onClickConfirm;
}

/// SearchView manage map / my location button / confirm button
class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<i18n.I18nProvider, SearchViewProvider>(
        builder: (context, i18nProvider, searchViewProvider, child) => Stack(
              children: <Widget>[
                locate.map(),
                Consumer<MyLocationButtonProvider>(
                  builder: (context, myLocationButtonProvider, child) => myLocationButtonProvider.visible
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(8),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    delta.CustomIcons.myLocation,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    i18nProvider.translate('myLoc'),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () => searchViewProvider.onClickMyLocation(context),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Consumer<ConfirmButtonProvider>(
                  builder: (context, confirmButtonProvider, child) => confirmButtonProvider.visible
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: confirmButtonProvider.visible ? 160 : 0,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                                  child: Text(
                                    i18nProvider.translate('correct'),
                                    style: TextStyle(fontSize: 24, color: Colors.grey[900]),
                                  ),
                                ),
                                confirmButton(context, 280, 54, 20, i18nProvider.translate('confirmAddr'), null,
                                    searchViewProvider.onClickConfirm),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ));
  }
}
