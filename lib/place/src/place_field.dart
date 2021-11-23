import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types/types.dart' as types;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/dialog/dialog.dart' as dialog;

import 'show_search.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.Field<types.Place> {
  const PlaceField({
    required Key key,
    required ValueNotifier<types.Place?> controller,
    String? label,
    bool requiredField = false,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          controller: controller,
          label: label,
          requiredField: requiredField,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  @override
  Widget build(BuildContext context) {
    return form.ClickField<types.Place>(
      key: key!,
      controller: controller,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      label: label,
      requiredField: requiredField,
      onClicked: (types.Place? place) async {
        // deviceLatLng might not return when use ios simulator custom location. define your location in simulator file
        final newPlace = await dialog.routeOrDialog(
          context,
          ChangeNotifierProvider<ShowSearchProvider>(
            create: (context) => ShowSearchProvider(context, place ?? types.Place.empty),
            child: const ShowSearch(),
          ),
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
