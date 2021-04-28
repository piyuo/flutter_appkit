import 'package:flutter/material.dart';
import 'package:libcli/src/i18n/i18n.dart' as i18n;

class Dropdown extends StatefulWidget {
  final TextEditingController controller;

  final String? label;

  final Map items;

  Dropdown({
    required this.controller,
    required this.items,
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  DropdownState createState() => DropdownState(items);
}

class DropdownState extends State<Dropdown> {
  List<DropdownMenuItem<String>> menuItems = [];

  DropdownState(Map items) {
    menuItems = itemsToMenuItems(items);
  }

  List<DropdownMenuItem<String>> itemsToMenuItems(Map items) {
    List<DropdownMenuItem<String>> result = [];
    items.forEach((key, value) {
      result.add(DropdownMenuItem<String>(
        child: Text(
          value,
          textWidthBasis: TextWidthBasis.parent,
          overflow: TextOverflow.ellipsis,
        ),
        value: key,
      ));
    });
    return result;
  }

  bool get isEmpty => widget.controller.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: menuItems,
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (String? value) {
        value = value ?? '';
        setState(() => widget.controller.text = value!);
      },
      validator: (String? text) {
        return text == null || text.trim().length == 0
            ? widget.label != null
                ? 'enterYour'.i18n_.replaceAll('%1', widget.label!.toLowerCase())
                : 'required'.i18n_
            : null;
      },
      value: widget.controller.text,
      decoration: !isEmpty
          ? InputDecoration(
              labelText: widget.label,
              hintText: widget.label,
            )
          : null,
    );
  }
}
