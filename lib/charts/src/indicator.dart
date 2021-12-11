import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

class Indicator extends StatelessWidget {
  const Indicator({
    required this.title,
    required this.text,
    Key? key,
  }) : super(key: key);

  final String title;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(
            color: context.themeColor(light: Colors.grey.shade400, dark: Colors.grey.shade700),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(25))),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 16,
                color: context.themeColor(light: Colors.grey.shade700, dark: Colors.grey.shade300),
              )),
          const SizedBox(height: 10),
          Text(text,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
