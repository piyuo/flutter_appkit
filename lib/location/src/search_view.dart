import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/location/location.dart' as location;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'search_confirm.dart';
import 'show_search.dart';

class SearchViewProvider with ChangeNotifier {
  SearchViewProvider({
    required this.myLocationButtonProvider,
    required this.confirmButtonProvider,
    required this.onClickMyLocation,
    required this.onClickConfirm,
  });

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
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewProvider>(
        builder: (context, searchViewProvider, child) => Stack(
              children: <Widget>[
                location.map(),
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
                                    Icons.my_location,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    context.i18n.placeMyLocation,
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
                                    context.i18n.placeIsAddressCorrect,
                                    style: TextStyle(fontSize: 24, color: Colors.grey[900]),
                                  ),
                                ),
                                confirmButton(context, 280, 54, 20, context.i18n.placeConfirmAddress, null,
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
