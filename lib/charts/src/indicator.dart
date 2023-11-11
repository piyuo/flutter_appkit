import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    required this.title,
    required this.text,
    super.key,
  });

  final String title;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(text, style: Theme.of(context).textTheme.displayLarge),
        ],
      ),
    ));
  }
}
