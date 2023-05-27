import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/utils/utils.dart' as general;
import 'package:libcli/form/form.dart' as form;
import 'package:libcli/dialog/dialog.dart' as dialog;

import 'show_search.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.FutureField<general.Place> {
  PlaceField({
    Key? key,
    String? formControlName,
    FormControl<general.Place>? formControl,
    Map<String, ValidationMessageFunction>? validationMessages,
    ShowErrorsFunction? showErrors,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
          key: key,
          formControlName: formControlName,
          formControl: formControl,
          validationMessages: validationMessages,
          showErrors: showErrors,
          decoration: decoration,
          valueBuilder: (general.Place? value) => value != null ? Text(value.address) : const SizedBox(),
          onPressed: (BuildContext context, general.Place? place) async {
            // deviceLatLng might not return when use ios simulator custom location. define your location in simulator file
            final newPlace = await dialog.routeOrDialog(
              context,
              ChangeNotifierProvider<ShowSearchProvider>(
                create: (context) => ShowSearchProvider(context, place ?? general.Place.empty),
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
