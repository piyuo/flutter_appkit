import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;
import 'package:libcli/form.dart' as form;

import 'show-search.dart';

/// PlaceField let user set his place, it contain address, lat/lng and address tags
class PlaceField extends form.Field {
  /// controller is place value controller
  final types.PlaceController controller;

  PlaceField({
    required this.controller,
    String? label,
    String? required,
    FocusNode? focusNode,
    Key? key,
  }) : super(
          key: key,
          label: label,
          required: required,
          focusNode: focusNode,
        );

  @override
  bool isEmpty() => controller.value.isEmpty;

  @override
  PlaceFieldState createState() => PlaceFieldState();
}

class PlaceFieldState extends State<PlaceField> {
  /// _textController for the click field
  final TextEditingController _textController = TextEditingController();

  /// _onClicked trigger when user click
  Future<String> _onClicked(String text) async {
    final place = await Navigator.push<types.Place>(
      context,
      MaterialPageRoute(
          builder: (context) => ShowSearch(
                place: widget.controller.value,
              )),
    );
    if (place != null) {
      widget.controller.value = place;
      setState(() {
        _textController.text = place.address;
      });
      return place.address;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return form.ClickField(
      controller: _textController,
      focusNode: widget.focusNode,
      label: widget.label,
      required: widget.required,
      onClicked: _onClicked,
    );
  }
}
