import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// TapOnButtonHint show hint to user to tap on button
///
class TapOnButtonHint extends StatelessWidget {
  const TapOnButtonHint(
    this._addObject, {
    Key? key,
  }) : super(key: key);

  final String _addObject;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.i18n.tapOnHint, style: const TextStyle(fontSize: 20, color: Colors.grey)),
                const SizedBox(width: 10),
                const Icon(
                  Icons.add_circle,
                  size: 40,
                  color: Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(context.i18n.tapOnHintAdd.replace1(_addObject),
                    style: const TextStyle(fontSize: 20, color: Colors.grey)),
              ],
            )),
        Center(
          child: Icon(
            Icons.south_east,
            size: 64,
            color: Colors.red[300],
          ),
        ),
      ],
    );
  }
}
