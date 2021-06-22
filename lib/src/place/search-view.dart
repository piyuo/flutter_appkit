import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/locate.dart' as locate;
import 'package:libcli/i18n.dart' as i18n;
import 'search-confirm.dart';

/// SearchView manage map / my location button / confirm button
class SearchView extends StatefulWidget {
  SearchView({
    required this.mapController,
    required this.showMyLocationButton,
    required this.confirmButtonController,
    required this.onClickMyLocation,
    required this.onClickConfirm,
    Key? key,
  }) : super(key: key);

  /// showMyLocation is true will show my location button
  final bool showMyLocationButton;

  /// mapController control map value
  final locate.MapValueController mapController;

  /// confirmButtonController control show confirm button
  final types.BoolController confirmButtonController;

  /// onClickMyLocation trigger when user click my location button
  final void Function() onClickMyLocation;

  /// onClickConfirm trigger when user click confirm
  final void Function() onClickConfirm;

  @override
  State<SearchView> createState() => SearchViewState();
}

class SearchViewState extends State<SearchView> {
  /// _showConfirmButton is true will show confirm button
  bool _showConfirmButton = false;

  @override
  void initState() {
    super.initState();
    widget.confirmButtonController.addListener(_confirmButtonChange);
  }

  @override
  void dispose() {
    widget.confirmButtonController.removeListener(_confirmButtonChange);
    super.dispose();
  }

  /// _confirmButtonChange trigger when confirm button need show or hide
  _confirmButtonChange() {
    setState(() {
      _showConfirmButton = widget.confirmButtonController.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Consumer<i18n.I18nProvider>(
        builder: (context, i18nProvider, child) => Stack(
              children: <Widget>[
                locate.platformMap(widget.mapController),
                widget.showMyLocationButton
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(8),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(20, 10, 20, 10)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.my_location,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  i18nProvider.translate('myLoc'),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: widget.onClickMyLocation,
                          ),
                        ),
                      )
                    : SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn,
                    padding: EdgeInsets.only(top: _showConfirmButton ? 0 : 100),
                    height: _showConfirmButton ? 160 : 0,
                    color: isDark ? Colors.black87 : Colors.white,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Text(
                            i18nProvider.translate('correct'),
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        confirmButton(
                            context, 280, 54, 20, i18nProvider.translate('confirmAddr'), null, widget.onClickConfirm),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}
