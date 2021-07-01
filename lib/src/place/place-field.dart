import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/form.dart' as form;
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/i18n.dart' as i18n;

import 'show-search.dart';

/// PlaceFieldProvider control place field
class PlaceFieldProvider extends ChangeNotifier {
  PlaceFieldProvider();

  types.Place place = types.Place.empty;

  /// _textController for the click field
  final TextEditingController _textController = TextEditingController();

  /// _onClicked trigger when user click
  Future<String> _onClicked(BuildContext context, String text) async {
    final newPlace = await dialog.routeOrDialog(
      context,
      MultiProvider(providers: [
        ChangeNotifierProvider<ShowSearchProvider>(
          create: (context) => ShowSearchProvider(context, place),
        ),
        ChangeNotifierProvider(
            create: (_) => i18n.I18nProvider(
                  fileName: 'place',
                  package: 'libcli',
                )),
      ], child: ShowSearch()),
    );

    if (newPlace != null) {
      place = newPlace;
    }
    notifyListeners();
    return place.address;
  }
}

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.Field {
  PlaceField({
    required this.controller,
    String? label,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          label: label,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// controller is place value controller
  final PlaceFieldProvider controller;

  @override
  bool isEmpty() => controller.place.isEmpty;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PlaceFieldProvider>.value(
      value: controller,
      child: Consumer<PlaceFieldProvider>(builder: (context, placeFieldProvider, child) {
        return form.ClickField(
          controller: placeFieldProvider._textController,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          label: label,
          require: require,
          onClicked: (text) => placeFieldProvider._onClicked(context, text),
        );
      }),
    );
  }
}
