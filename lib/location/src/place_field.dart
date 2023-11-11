import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/dialog/dialog.dart' as dialog;

import 'show_search.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.FutureField<utils.Place> {
  PlaceField({
    super.key,
    super.formControlName,
    super.formControl,
    super.validationMessages,
    super.showErrors,
    super.decoration,
  }) : super(
          valueBuilder: (utils.Place? value) => value != null ? Text(value.address) : const SizedBox(),
          onPressed: (BuildContext context, utils.Place? place) async {
            // deviceLatLng might not return when use ios simulator custom location. define your location in simulator file
            final newPlace = await dialog.routeOrDialog(
              context,
              ChangeNotifierProvider<ShowSearchProvider>(
                create: (context) => ShowSearchProvider(context, place ?? utils.Place.empty),
                child: const ShowSearch(),
              ),
            );

            if (newPlace != null) {
              return newPlace;
            }
            return place;
          },
        );
}
