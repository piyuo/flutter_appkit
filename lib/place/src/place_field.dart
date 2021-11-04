import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;

import 'show_search.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.Field<types.Place> {
  const PlaceField({
    required Key key,
    required this.controller,
    String? label,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          label: label,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// controller is place value controller
  final ValueNotifier<types.Place?> controller;

  @override
  Widget build(BuildContext context) {
    return form.ClickField<types.Place>(
      key: key!,
      controller: controller,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      label: label,
      require: require,
      onClicked: (types.Place? place) async {
        // deviceLatLng might not return when use ios simulator custom location. define your location in simulator file
        final newPlace = await dialog.routeOrDialog(
          context,
          MultiProvider(providers: [
            ChangeNotifierProvider<ShowSearchProvider>(
              create: (context) => ShowSearchProvider(context, place ?? types.Place.empty),
            ),
            ChangeNotifierProvider(
                create: (_) => i18n.I18nProvider(
                      fileName: 'place',
                      package: 'libcli',
                    )),
          ], child: const ShowSearch()),
        );

        if (newPlace != null) {
          return newPlace;
        }
        return place;
      },
      valueToString: (types.Place? place) => place != null ? place.address : '',
    );
  }
}
